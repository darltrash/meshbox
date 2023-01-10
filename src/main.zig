const std = @import("std");
const SDL = @import("sdl2");
const sg = @import("sokol").gfx;
const st = @import("sokol").time;
const sd = @import("sokol").debugtext;
const kf = @import("known-folders");
const raw = @import("c");
const render_shader = @import("render.glsl.zig");
const output_shader = @import("output.glsl.zig");

const lua = @import("lua.zig");
const iqm = @import("iqm.zig");

const MaxVertexAmount: usize = 100_000;
const MaxIndexAmount: usize = MaxVertexAmount * 6;

pub const Vertex = extern struct {
    x: f32 = 0, y: f32 = 0, z: f32 = 0,
    nx: f32 = 0, ny: f32 = 0, nz: f32 = 0,
    u: f32 = 0, v: f32 = 0,
    r: f32 = 1, g: f32 = 1, b: f32 = 1, a: f32 = 1
};

pub const Rectangle = extern struct {
    x: u32 = 0, y: u32 = 0, 
    w: u32 = 0, h: u32 = 0
};

var resolution: Rectangle = .{
    .w = 640, .h = 480
};

var window: SDL.Window = undefined;

var render_pipeline: sg.Pipeline = undefined;
var render_bindings: sg.Bindings = .{};
var render_pass: sg.Pass = .{};
var render_pass_action: sg.PassAction = .{};

var output_pipeline: sg.Pipeline = undefined;
var output_bindings: sg.Bindings = .{};
var output_pass_action: sg.PassAction = .{};

var text_pass_action: sg.PassAction = .{};

var vertices: std.ArrayList(Vertex) = undefined;
var current_viewport: Rectangle = .{};
var should_quit = false;
var focus = true;

var calls: usize = 0;

pub const wn = struct {
    pub fn title(t: []const u8) !void {
        SDL.c.SDL_SetWindowTitle(window.ptr, try std.cstr.addNullByte(allocator, t));
    }

    pub fn quit() void {
        should_quit = true;
    }

    pub fn focused() bool {
        return focus;
    }
};

pub const fs = struct {
    var directory: ?std.fs.Dir = null;

    pub fn init(where: []const u8) !void {
        directory = try std.fs.cwd().openDir(where, .{});
    }

    pub fn read(what: []const u8) !?[]const u8 {
        var stat: ?std.fs.File.Stat = directory.?.statFile(what) catch null;
        if (stat == null) return null;

        return try directory.?.readFileAlloc(allocator, what, stat.?.size);
    }
};

// Savefile module
pub const sv = struct {
    var directory: std.fs.Dir = undefined;
    var file: ?std.fs.File = undefined;
    var enabled: bool = true;

    pub fn init() !void {
        var d: ?std.fs.Dir = try kf.open(allocator, .data, .{});
        try d.?.makePath("meshbox");
        directory = try d.?.openDir("meshbox", .{});
        d.?.close();
    }

    pub fn identity(id: []const u8) !bool {
        if (file != null) return false;

        var copy = try allocator.alloc(u8, id.len+5);
        std.mem.copy(u8, copy, id);
        for (copy) | *e | {
            switch (e.*) {
                'a'...'z',
                'A'...'Z',
                '0'...'9',
                '-', '_', ' ' => {},

                else => {
                    e.* = '_';
                }
            }
        }
        std.mem.copy(u8, copy[id.len..], ".save");

        file = try directory.createFile(copy, .{ 
            .read = true,
            .truncate = false
        });
        std.log.info("OPENED: {s}", .{copy});

        return true;
    }

    const saveSizeLimit: usize = 1024; // About a megabyte

    pub fn write(content: []const u8) !bool {
        if (file == null) return false;

        if (content.len > saveSizeLimit) {
            return error.tooBig;
        }

        _ = try file.?.write(content);
        try file.?.seekTo(0);
        
        return true;
    }

    pub fn read() !?[]const u8 {
        if (file == null) return null;

        var stat = try file.?.stat();
        var size = std.math.min(saveSizeLimit, @intCast(usize, stat.size));
        
        var o = try file.?.readToEndAlloc(allocator, size);
        try file.?.seekTo(0);
        return o;
    }
};

// Matrix module
pub const mx = struct {
    pub const Modes = enum {
        model, view, projection
    };

    pub const Matrix = [4*4]f32;

    pub const matrix_identity = Matrix {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    };

    var model:      Matrix = undefined;
    var view:       Matrix = undefined;
    var projection: Matrix = undefined;
    var current:   *Matrix = undefined;

    pub fn mode(m: Modes) void {
        switch (m) {
            .model => current = &model,
            .view => current = &view,
            .projection => current = &projection
        }
    }

    pub fn set(m: Matrix) void {
        std.mem.copy(f32, current, &m);
    }

    pub fn get() Matrix {
        return current.*;
    }

    pub fn identity() void {
        set(matrix_identity);
    }

    pub fn multiply(m: Matrix) void {
        set(.{
            m[0]  * current.*[0] + m[1]  * current.*[4] + m[2]  * current.*[8]  + m[3]  * current.*[12],
            m[0]  * current.*[1] + m[1]  * current.*[5] + m[2]  * current.*[9]  + m[3]  * current.*[13],
            m[0]  * current.*[2] + m[1]  * current.*[6] + m[2]  * current.*[10] + m[3]  * current.*[14],
            m[0]  * current.*[3] + m[1]  * current.*[7] + m[2]  * current.*[11] + m[3]  * current.*[15],
            m[4]  * current.*[0] + m[5]  * current.*[4] + m[6]  * current.*[8]  + m[7]  * current.*[12],
            m[4]  * current.*[1] + m[5]  * current.*[5] + m[6]  * current.*[9]  + m[7]  * current.*[13],
            m[4]  * current.*[2] + m[5]  * current.*[6] + m[6]  * current.*[10] + m[7]  * current.*[14],
            m[4]  * current.*[3] + m[5]  * current.*[7] + m[6]  * current.*[11] + m[7]  * current.*[15],
            m[8]  * current.*[0] + m[9]  * current.*[4] + m[10] * current.*[8]  + m[11] * current.*[12],
            m[8]  * current.*[1] + m[9]  * current.*[5] + m[10] * current.*[9]  + m[11] * current.*[13],
            m[8]  * current.*[2] + m[9]  * current.*[6] + m[10] * current.*[10] + m[11] * current.*[14],
            m[8]  * current.*[3] + m[9]  * current.*[7] + m[10] * current.*[11] + m[11] * current.*[15],
            m[12] * current.*[0] + m[13] * current.*[4] + m[14] * current.*[8]  + m[15] * current.*[12],
            m[12] * current.*[1] + m[13] * current.*[5] + m[14] * current.*[9]  + m[15] * current.*[13],
            m[12] * current.*[2] + m[13] * current.*[6] + m[14] * current.*[10] + m[15] * current.*[14],
            m[12] * current.*[3] + m[13] * current.*[7] + m[14] * current.*[11] + m[15] * current.*[15]
        });
    }

    pub fn perspective(fov: f32, near: f32, far: f32) void {
        identity();

        var t = std.math.tan(fov * (std.math.pi / 180.0) * 0.5);
        var aspect = @intToFloat(f32, current_viewport.w)/@intToFloat(f32, current_viewport.h);

        current.*[0]  =  1 / (t * aspect);
        current.*[5]  =  1 / t;
        current.*[10] = -(far + near) / (far - near);
        current.*[11] = -1;
        current.*[14] = -(2 * far * near) / (far - near);
        current.*[15] =  0;
    }

    pub fn orthographic(near: f32, far: f32) void {
        identity();

        var right  = @intToFloat(f32, current_viewport.w);
        var bottom = @intToFloat(f32, current_viewport.h);

        current.*[0]  =  2 / right;
        current.*[5]  =  2 / -bottom;
        current.*[10] = -2 / (far - near);
        current.*[12] = -1;
        current.*[13] = -(bottom / -bottom);
        current.*[14] = -((far + near) / (far - near));
        current.*[15] =  1;
    }

    fn _normalize(x: f32, y: f32, z: f32) [3]f32 {
        var l = std.math.sqrt(std.math.pow(f32, x, 2) + std.math.pow(f32, y, 2) + std.math.pow(f32, z, 2));
        return [3]f32 { x/l, y/l, z/l };
    }

    fn _cross(
        ax: f32, ay: f32, az: f32,
        bx: f32, by: f32, bz: f32

    ) [3]f32 {
        return [3]f32 { 
            ay * bz - az * by,
            az * bx - ax * bz,
            ax * by - ay * bx
        };
    }

    pub fn look_at(
        ex: f32, ey: f32, ez: f32, 
        ax: f32, ay: f32, az: f32, 
        ux: f32, uy: f32, uz: f32
    ) void {
        var zp = _normalize(
            ex - ax,
            ey - ay,
            ez - az,
        );

        var _p = _cross(
            ux, uy, uz,
            zp[0], zp[1], zp[2]
        );
        var xp = _normalize(_p[0], _p[1], _p[2]);

        var yp = _cross(
            zp[0], zp[1], zp[2],
            xp[0], xp[1], xp[2],
        );

        var o = matrix_identity;

        o[ 0] = xp[0];
	    o[ 1] = yp[0];
	    o[ 2] = zp[0];
	    o[ 3] = 0;
	    o[ 4] = xp[1];
	    o[ 5] = yp[1];
	    o[ 6] = zp[1];
	    o[ 7] = 0;
	    o[ 8] = xp[2];
	    o[ 9] = yp[2];
	    o[10] = zp[2];
	    o[11] = 0;
        o[12] = -o[0]*ex - o[4]*ey - o[ 8]*ez;
        o[13] = -o[1]*ex - o[5]*ey - o[ 9]*ez;
        o[14] = -o[2]*ex - o[6]*ey - o[10]*ez;
        o[15] = -o[3]*ex - o[7]*ey - o[11]*ez + 1;

        set(o);
    }

    pub fn translate(x: f32, y: f32, z: f32) void {
        var o = matrix_identity;

        o[12] = x;
        o[13] = y;
        o[14] = z;

        multiply(o);
    }

    pub fn rotate(a: f32, x: f32, y: f32, z: f32) void {
        var o = matrix_identity;
        var t = _normalize(x, y, z);

        var c = std.math.cos(@mod(a, std.math.tau));
        var s = std.math.sin(@mod(a, std.math.tau));

        const _x = 0;
        const _y = 1;
        const _z = 2;

        o[ 0] = t[_x] * t[_x] * (1 - c) + c;
        o[ 1] = t[_y] * t[_x] * (1 - c) + t[_z] * s;
        o[ 2] = t[_x] * t[_z] * (1 - c) - t[_y] * s;
        o[ 4] = t[_x] * t[_y] * (1 - c) - t[_z] * s;
        o[ 5] = t[_y] * t[_y] * (1 - c) + c;
        o[ 6] = t[_y] * t[_z] * (1 - c) + t[_x] * s;
        o[ 8] = t[_x] * t[_z] * (1 - c) + t[_y] * s;
        o[ 9] = t[_y] * t[_z] * (1 - c) - t[_x] * s;
        o[10] = t[_z] * t[_z] * (1 - c) + c;

        multiply(o);
    }

    pub fn euler(x: f32, y: f32, z: f32) void {
        rotate(x, 1, 0, 0);
        rotate(y, 0, 1, 0);
        rotate(z, 0, 0, 1);
    }

    pub fn scale(x: f32, y: f32, z: f32) void {
        var o = matrix_identity;

        o[0]  = x;
        o[5]  = y;
        o[10] = z;
        
        multiply(o);
    }
};

// Vertex module
pub const vx = struct {
    var current: Vertex = .{};

    const Mesh = struct {
        vertices: []Vertex,
        indices: []u16
    };

    pub fn load(file: []const u8) !?Mesh {
        var data = try fs.read(file);
        if (data == null) return null;

        var model = try iqm.fromBuffer(data.?, false, allocator);

        var indices_out = try allocator.alloc(u16, model.indices.len);
        for (model.indices) | index, k |
            indices_out[k] = @intCast(u16, index);

        var vertices_out = try allocator.alloc(Vertex, model.vertices);
        for (vertices_out) | *v, k | {
            v.*.x = model.positions[(k * 3)+0];
            v.*.y = model.positions[(k * 3)+1];
            v.*.z = model.positions[(k * 3)+2];

            v.*.nx = model.normals[(k * 3)+0];
            v.*.ny = model.normals[(k * 3)+1];
            v.*.nz = model.normals[(k * 3)+2];

            v.*.u = model.texcoords[(k * 2)+0];
            v.*.v = model.texcoords[(k * 2)+1];

            v.*.r = @intToFloat(f32, model.color[(k * 4)+0]) / 255;
            v.*.g = @intToFloat(f32, model.color[(k * 4)+1]) / 255;
            v.*.b = @intToFloat(f32, model.color[(k * 4)+2]) / 255;
            v.*.a = @intToFloat(f32, model.color[(k * 4)+3]) / 255;
        }

        return Mesh {
            .vertices = vertices_out,
            .indices = indices_out
        };
    }

    pub fn normal(x: f32, y: f32, z: f32) void {
        current.nx = x;
        current.ny = y;
        current.nz = z;
    }

    pub fn texcoord(u: f32, v: f32) void {
        current.u = u;
        current.v = v;
    }

    pub fn color(r: f32, g: f32, b: f32, a: f32) void {
        current.r = r;
        current.g = g;
        current.b = b;
        current.a = a;
    }

    pub fn vertex(x: f32, y: f32, z: f32) !void {
        current.x = x;
        current.y = y;
        current.z = z;

        try vertices.append(current);
        current = .{};
    }

    pub fn mesh(vertices_tmp: []Vertex) !void {
        try vertices.appendSlice(vertices_tmp);
    }

    pub fn render(raw_indices: ?[]u16) !void {
        var indices = std.ArrayList(u16).init(allocator);

        if (raw_indices != null)
            try indices.appendSlice(raw_indices.?)
        else {
            for (vertices.items) | _, k | {
                try indices.append(@intCast(u16, k));
            } 
        }

        _ = sg.appendBuffer(render_bindings.index_buffer, sg.asRange(indices.items));
        _ = sg.appendBuffer(render_bindings.vertex_buffers[0], sg.asRange(vertices.items));

        sg.applyBindings(render_bindings);
        send_uniforms();

        sg.draw(0, @intCast(u32, indices.items.len), 1);

        render_bindings.vertex_buffer_offsets[0] += @intCast(i32, @sizeOf(Vertex) * vertices.items.len);
        render_bindings.index_buffer_offset      += @intCast(i32, @sizeOf(u16)    * indices.items.len );
        
        indices.deinit();
        vertices.clearAndFree();
        calls += 1;
    }
};

// Lighting module
pub const li = struct { 
    var fshader: render_shader.FsUniforms = .{
        .ambient = undefined,
        .light_position = undefined,
        .light_color = undefined,
        .light_amounts = 0
    };

    const maxLightAmount: usize = 16;
    var ambient_color = [4]f32 {0, 0, 0, 0};
    var light_amount: usize = 0;

    pub fn ambient(r: f32, g: f32, b: f32, a: f32) void {
        fshader.ambient[0] = r;
        fshader.ambient[1] = g;
        fshader.ambient[2] = b;
        fshader.ambient[3] = a;
    }

    pub fn clear() void {
        fshader.light_amounts = 0;
    }

    pub const LightType = enum(i32) {
        directional, point
    };

    pub fn light(
        t: LightType,
        x: f32, y: f32, z: f32, 
        r: f32, g: f32, b: f32
    ) void {
        var tt = @intToFloat(f32, @enumToInt(t));
        var i = @intCast(usize, fshader.light_amounts);

        fshader.light_position[i] = [4]f32 {
            x, y, z, tt
        };

        fshader.light_color[i] = [4]f32 {
            r, g, b, 0
        };

        fshader.light_amounts += 1;
    }
};

pub const tx = struct {
    var texture_map: std.StringHashMap(sg.Image) = undefined;
    var default: sg.Image = undefined;

    pub fn init() !void {
        texture_map = @TypeOf(texture_map).init(allocator);

        var image_data: sg.ImageData = .{};
        image_data.subimage[0][0] = sg.asRange(&[1]u32{0xffffffff});
        default = sg.makeImage(.{
            .width = 1, .height = 1,
            .data = image_data
        });

        try texture_map.put("<meshbox>", load(@embedFile("assets/meshbox.png")) orelse unreachable);
    } 

    fn load(compressed_bytes: []const u8) ?sg.Image {
        var width:  c_int = 0;
        var height: c_int = 0;

        if (raw.stbi_info_from_memory(compressed_bytes.ptr, @intCast(c_int, compressed_bytes.len), &width, &height, null) == 0) {
            return null;
        }

        if (width <= 0 or height <= 0) return null;

        if (raw.stbi_is_16_bit_from_memory(compressed_bytes.ptr, @intCast(c_int, compressed_bytes.len)) != 0)
            return null;
        //raw.stbi_set_flip_vertically_on_load(1);

        const data = raw.stbi_load_from_memory(compressed_bytes.ptr, @intCast(c_int, compressed_bytes.len), &width, &height, null, 4);
        if (data == null) return null;

        var image_data: sg.ImageData = .{};
        image_data.subimage[0][0] = sg.asRange(data[0 .. @intCast(usize, height * width * 4)]);
        var pi = sg.makeImage(.{
            .width = @intCast(i32, width), 
            .height =  @intCast(i32, height),
            .data = image_data
        });

        return pi;
    }

    pub fn bind(file: ?[]const u8) !bool {
        var f = file orelse {
            render_bindings.fs_images[render_shader.SLOT_tex] = default;
            return true;
        };

        render_bindings.fs_images[render_shader.SLOT_tex] = 
            texture_map.get(f) orelse blk: {
                var d = (try fs.read(f)) orelse return false;
                var pi = load(d) orelse return false;
                
                try texture_map.put(f, pi);

                break :blk pi;
            };

        return true;
    }

    pub fn unload(file: []const u8) bool {
        return texture_map.remove(file);
    }
};

pub const in = struct {
    pub const Vector = [2]f32;

    pub const Joystick = enum {
        left, right
    };

    pub const Kind = enum (u8) {
        joyleft_up,  joyleft_down,  joyleft_left,  joyleft_right,
        joyright_up, joyright_down, joyright_left, joyright_right,
        x, y, a, b, shoulder_left, shoulder_right
    };

    pub const Method = enum {
        keyboard, mouse, mouse_button, joystick
    };

    pub const Map = union (Method) {
        keyboard: SDL.Keycode,
        mouse_button: SDL.MouseButton,
        mouse: [2]i8,
        joystick: u32,
    };

    pub const State = struct {
        frames: u32 = 0, 
        intensity: f32 = 0,
        instant: bool = false
    };

    var input_map:  std.AutoHashMap(Map,  Kind)  = undefined;
    var kind_state: [15]State = undefined;

    pub fn init(alloc: std.mem.Allocator) !void {
        input_map  = @TypeOf(input_map).init(alloc);

        // TODO: Add input loading system

        try register(.{.keyboard = .w }, .joyleft_up);
        try register(.{.keyboard = .s }, .joyleft_down);
        try register(.{.keyboard = .a }, .joyleft_left);
        try register(.{.keyboard = .d }, .joyleft_right);
        try register(.{.mouse = .{ 0, -1}}, .joyright_up);
        try register(.{.mouse = .{ 0,  1}}, .joyright_down);
        try register(.{.mouse = .{-1,  0}}, .joyright_left);
        try register(.{.mouse = .{ 1,  0}}, .joyright_right);
        try register(.{.keyboard = .z }, .x);
        try register(.{.keyboard = .x }, .y);
        try register(.{.keyboard = .c }, .a);
        try register(.{.keyboard = .v }, .b);

        try register(.{.mouse_button = .left }, .shoulder_left);
        try register(.{.mouse_button = .right}, .shoulder_right);
    }

    pub fn register(what: Map, to: Kind) !void {
        try input_map.put(what, to);
    }

    // Returns the intensity of the input specified, by
    // nature, it returns 0 if it's not pressed.
    pub fn button(id: Kind) f32 {
        var out = kind_state[@enumToInt(id)];
        return out.intensity;
    }

    pub fn frames(id: Kind) u32 {
        var out = kind_state[@enumToInt(id)];
        return out.frames;
    }

    // Returns a Vector ([2]f32) with a max length of 1
    // which represents either a virtual joystick like
    // a keyboard and mouse, or a real joystick
    pub fn joystick(j: Joystick) Vector {
        var out: Vector = .{};

        // ugly solution, but works alright 👍
        switch(j) {
            .left => {
                out[0] = button(.joyleft_right) - button(.joyleft_left);
                out[1] = button(.joyleft_down)  - button(.joyleft_up);
            },

            .right => {
                out[0] = button(.joyright_left) - button(.joyright_right);
                out[1] = button(.joyright_down) - button(.joyright_up)   ;
            }
        }
        return out;
    }

    // Internal usage only
    pub fn update() void {
        for (kind_state) | *v | {
            if (v.frames > 1 and v.instant) 
                v.*.intensity = 0;
            
            if (v.*.intensity > 0)
                v.*.frames += 1
            else
                v.*.frames = 0;
        }
    }

    // TODO: ADD JOYSTICK STUFFFFFF
    // Internal usage only

    var mouse_enabled = false;
    pub fn handle(event: SDL.Event) !void {
        switch (event) {
            .key_down, .key_up => |k| {
                if (k.keycode == .escape) {
                    mouse_enabled = false;
                    _ = SDL.c.SDL_SetRelativeMouseMode(0);
                }

                if (k.is_repeat) return;
                
                var kind = input_map.get(.{ .keyboard = k.keycode }) 
                    orelse return;

                kind_state[@enumToInt(kind)].intensity = 
                    if (k.key_state == .pressed) 1 else 0;
            },

            .mouse_motion => |m| {
                if (!mouse_enabled) return;

                var sx = @intCast(i8, std.math.sign(m.delta_x));
                {
                    var kind = input_map.get(.{ 
                        .mouse = .{ 
                            sx, 0
                        } 
                    }) orelse return;

                    kind_state[@enumToInt(kind)].intensity 
                        = std.math.min(100.0, @intToFloat(f32, std.math.absCast(m.delta_x)) / 100);
                
                    kind_state[@enumToInt(kind)].instant = true;
                }

                var sy = @intCast(i8, std.math.sign(m.delta_y));
                {
                    var kind = input_map.get(.{ 
                        .mouse = .{ 
                            0, sy
                        } 
                    }) orelse return;

                    kind_state[@enumToInt(kind)].instant = true;

                    kind_state[@enumToInt(kind)].intensity 
                        = std.math.min(100.0, @intToFloat(f32, std.math.absCast(m.delta_y)) / 100);
                }
            },

            .mouse_button_down, .mouse_button_up => |b| {
                mouse_enabled = true;
                _ = SDL.c.SDL_SetRelativeMouseMode(1);
                var kind = input_map.get(.{ .mouse_button = b.button }) 
                    orelse return;

                kind_state[@enumToInt(kind)].intensity = 
                    if (b.state == .pressed) 1 else 0;
            },

            else => {}
        }
    }
};

// General module
pub const gx = struct {
    pub fn width() u32 {
        return resolution.w;
    }

    pub fn height() u32 {
        return resolution.h;
    }

    pub fn scissor(s: ?Rectangle) void {
        if (s == null)
            return sg.applyScissorRect(
                0, 0, 
                @intCast(i32, width()), 
                @intCast(i32, height()),
                true
            );

        sg.applyScissorRect(
            @intCast(i32, s.?.x), @intCast(i32, s.?.y), 
            @intCast(i32, s.?.w), @intCast(i32, s.?.h),
            true
        );
    }

    pub fn viewport(v: ?Rectangle) void {
        current_viewport = v orelse resolution;

        sg.applyScissorRect(
            @intCast(i32, current_viewport.x),
            @intCast(i32, current_viewport.y), 
            @intCast(i32, current_viewport.w), 
            @intCast(i32, current_viewport.h),
            true
        );
    }

    pub fn background(r: f32, g: f32, b: f32, a: f32) void {
        render_pass_action.colors[0].value.r = r;
        render_pass_action.colors[0].value.g = g;
        render_pass_action.colors[0].value.b = b;
        render_pass_action.colors[0].value.a = a;
    }
};

/////////////////////////////////////////////////////////

pub var allocator: std.mem.Allocator = undefined;

fn init() !void {
    var args = try std.process.argsAlloc(allocator);
    var no_game = true;
    var skip_intro = false;

    if (args.len > 1) {
        try fs.init(std.mem.span(args[1]));
        no_game = false;
    }

    try in.init(allocator);
    try sv.init();
    try tx.init();
    vertices = @TypeOf(vertices).init(allocator);

    var render_texture_desc: sg.ImageDesc = .{
        .render_target = true,
        .width =  @intCast(i32, gx.width()),
        .height = @intCast(i32, gx.height()),
        .pixel_format = .RGBA8,
        .min_filter = .NEAREST,
        .mag_filter = .NEAREST,
        .wrap_u = .REPEAT,
        .wrap_v = .REPEAT,
        .sample_count = 0
    };
    const color_img = sg.makeImage(render_texture_desc);
    render_texture_desc.pixel_format = .DEPTH;
    const depth_img = sg.makeImage(render_texture_desc);

    {
        render_bindings.vertex_buffers[0] = sg.makeBuffer(.{
            .type = .VERTEXBUFFER,
            .usage = .STREAM,
            .size = MaxVertexAmount * @sizeOf(Vertex)
        });

        render_bindings.index_buffer = sg.makeBuffer(.{
            .type = .INDEXBUFFER,
            .usage = .STREAM,
            .size = MaxIndexAmount * @sizeOf(u16)
        });

        var pass_desc: sg.PassDesc = .{};
        pass_desc.color_attachments[0].image = color_img;
        pass_desc.depth_stencil_attachment.image = depth_img;
        render_pass = sg.makePass(pass_desc);

        var pip_desc: sg.PipelineDesc = .{
            .shader = sg.makeShader(render_shader.renderShaderDesc(sg.queryBackend())),
            .index_type = .UINT16,
            .cull_mode = .BACK,
            .sample_count = 0,
            .depth = .{
                .pixel_format = .DEPTH,
                .compare = .LESS_EQUAL,
                .write_enabled = true,
            },
        };
        
        pip_desc.colors[0].pixel_format = .RGBA8;
        pip_desc.colors[0].blend = .{
            .enabled = true,
            .src_factor_rgb = .SRC_ALPHA,
            .dst_factor_rgb = .ONE_MINUS_SRC_ALPHA,
            .src_factor_alpha = .SRC_ALPHA,
            .dst_factor_alpha = .ONE_MINUS_SRC_ALPHA,
        };
        
        pip_desc.layout.attrs[render_shader.ATTR_vs_vx_position].format = .FLOAT3;
        pip_desc.layout.attrs[render_shader.ATTR_vs_vx_normal].format = .FLOAT3;
        pip_desc.layout.attrs[render_shader.ATTR_vs_vx_texcoord].format = .FLOAT2; 
        pip_desc.layout.attrs[render_shader.ATTR_vs_vx_color].format = .FLOAT4; 

        render_pipeline = sg.makePipeline(pip_desc);
        render_pass_action.colors[0] = .{ .action = .CLEAR, .value = .{ .r=0, .g=0, .b=0, .a=1.0 } };
    }

    {
        output_bindings.vertex_buffers[0] = sg.makeBuffer(.{
            .data = sg.asRange(&[_]f32{ -1, 1, 1, 1, 1, -1, -1, -1 })
        });

        output_bindings.index_buffer = sg.makeBuffer(.{
            .type = .INDEXBUFFER,
            .data = sg.asRange(&[_]u16{ 0, 1, 2, 0, 2, 3 })
        });

        output_bindings.fs_images[0] = color_img;
        
        var pip_desc: sg.PipelineDesc = .{
            .index_type = .UINT16,
            .shader = sg.makeShader(output_shader.outShaderDesc(sg.queryBackend())),
        };
        pip_desc.layout.attrs[output_shader.ATTR_vs_vx_position].format = .FLOAT2;

        output_pipeline = sg.makePipeline(pip_desc);

        output_pass_action.colors[0] = .{ .action=.CLEAR, .value=.{ .r=0, .g=0, .b=0, .a=1 } };
    }

    try lua.init(allocator, skip_intro, no_game);
}

fn send_uniforms() void {
    var vs: render_shader.VsUniforms = .{
        .model = mx.model,
        .view = mx.view,
        .projection = mx.projection,
        .resolution = [2]f32 {
            @intToFloat(f32, gx.width()),
            @intToFloat(f32, gx.height())
        }
    };

    sg.applyUniforms(.VS, render_shader.SLOT_vs_uniforms, sg.asRange(&vs));
    sg.applyUniforms(.FS, render_shader.SLOT_fs_uniforms, sg.asRange(&li.fshader));
}

/////////////////////////////////////////////////////////

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .enable_memory_limit = true
    }){};
    gpa.setRequestedMemoryLimit(128 * 1_048_576); // 128 MB
    allocator = gpa.allocator();

    try SDL.init(.{
        .video = true,
        .events = true,
        .audio = true,
        .game_controller = true,
        .joystick = true
    });
    defer SDL.quit();

    // TODO: Port this over to other backends.
    window = try SDL.createWindow(
        "meshbox", .{ .centered = {} }, .{ .centered = {} },
        640, 480, .{ .vis = .shown, .resizable = true, .context=.opengl },
    );
    defer window.destroy();

    try SDL.gl.setAttribute(.{ .context_profile_mask=.es });
    try SDL.gl.setAttribute(.{ .context_major_version=2 });
    try SDL.gl.setAttribute(.{ .context_minor_version=0 });

    var context = try SDL.gl.createContext(window);
    try SDL.gl.setSwapInterval(.adaptive_vsync);
    try SDL.gl.makeCurrent(context, window);

    sg.setup(.{});
    st.setup();

    var sdtx_desc: sd.Desc = .{};
    sdtx_desc.fonts[0] = sd.fontZ1013();
    sd.setup(sdtx_desc);
    text_pass_action.colors[0].action = .DONTCARE;

    try init();

    var last = st.now();
    var delta: f64 = 0;

    var debug = std.process.hasEnvVarConstant("MESHBOX_DEBUG");

    mainLoop: while (!should_quit) {
        var diff = st.laptime(&last);
        delta = @intToFloat(f64, diff) / 1_000_000_000.0;
        
        while (SDL.pollEvent()) |ev| {
            try in.handle(ev);
            switch (ev) {
                .app_did_enter_background => 
                    focus = false,
            
                .app_did_enter_foreground => 
                    focus = true,

                .quit => break :mainLoop,
                else => {},
            }
        }
        in.update();

        _ = try tx.bind(null);
        gx.scissor(null);
        gx.viewport(null);

        li.clear();
        li.ambient(1, 1, 1, 1);

        mx.mode(.model);
        mx.identity();
        mx.mode(.view);
        mx.identity();
        mx.mode(.projection);
        mx.identity();

        calls = 0;

        sg.beginPass(render_pass, render_pass_action);
            sg.applyPipeline(render_pipeline);
            render_bindings.vertex_buffer_offsets[0] = 0;
            render_bindings.index_buffer_offset      = 0;

            try lua.frame(delta);
        sg.endPass();

        var size = window.getSize();
        sg.beginDefaultPass(output_pass_action, size.width, size.height);
            sg.applyPipeline(output_pipeline);
            sg.applyBindings(output_bindings);
            sg.draw(0, 6, 1);
        sg.endPass();
        
        if (debug) {
            sd.canvas(@intToFloat(f32, size.width)/2, @intToFloat(f32, size.height)/2);
                sd.color1i(0xffffffff);
                sd.origin(2, 2);
                sd.font(0);
                const mem = @intToFloat(f32, gpa.total_requested_bytes)/1_048_576;
                sd.print("Memory: {d:.01}MB", .{mem});
                sd.crlf();
                sd.print("Calls: {}", .{calls});
                sd.crlf();
                sd.print("Frame: {}ns", .{diff});
                sd.crlf();

            sg.beginDefaultPass(text_pass_action, size.width, size.height);
                sd.draw();
            sg.endPass();
        }

        sg.commit();
        SDL.gl.swapWindow(window);
    }
}