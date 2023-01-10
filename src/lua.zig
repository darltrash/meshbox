const std = @import("std");
const meshbox = @import("main.zig");
const ziglua = @import("ziglua");
const Lua = ziglua.Lua;

const lua_fn = struct {
    fn mb_none(_: *Lua) i32 {
        return 0;
    }

    pub const mb_frame = mb_none;


    // wn_title(title)
    pub fn wn_title(l: *Lua) i32 {
        var str = std.mem.span(l.checkString(1));
        meshbox.wn.title(str) catch unreachable;
        return 0;
    }

    // local focused = wn_focused()
    pub fn wn_focused(l: *Lua) i32 {
        l.pushBoolean(meshbox.wn.focused());
        return 1;
    }

    // wn_quit()
    pub fn wn_quit(_: *Lua) i32 {
        meshbox.wn.quit();
        return 0;
    }


    // local done = sv_identity(id)
    pub fn sv_identity(l: *Lua) i32 {
        var str = std.mem.span(l.checkString(1));
        var o = meshbox.sv.identity(str) catch unreachable;
        l.pushBoolean(o);
        return 1;
    }

    // local done = sv_write(save)
    pub fn sv_write(l: *Lua) i32 {
        var str = std.mem.span(l.checkString(1));
        var o = meshbox.sv.write(str) catch unreachable;
        l.pushBoolean(o);
        return 1;
    }

    // local save_or_false = sv_read()
    pub fn sv_read(l: *Lua) i32 {
        var out = meshbox.sv.read() catch unreachable;
        if (out == null)
            l.pushBoolean(false)
        else
            l.pushString(out.?);
        return 1;
    }


    // local file_or_false = fs_read(file)
    pub fn fs_read(l: *Lua) i32 {
        var str = std.mem.span(l.checkString(1));
        var out = meshbox.fs.read(str) catch unreachable;
        if (out == null)
            l.pushBoolean(false)
        else
            l.pushString(out.?);
        return 1;
    }


    // local x, y = in_joystick(joystick)
    pub fn in_joystick(l: *Lua) i32 {
        var mode = l.checkOption(meshbox.in.Joystick, 1, .left);
        var out = meshbox.in.joystick(mode);
        l.pushNumber(@floatCast(f64, out[0]));
        l.pushNumber(@floatCast(f64, out[1]));
        return 2;
    }

    // local active, intensity, frames = in_button(key)
    pub fn in_button(l: *Lua) i32 {
        var mode = l.checkOption(meshbox.in.Kind, 1, .x);
        var intensity = meshbox.in.button(mode);
        var frames = meshbox.in.frames(mode);
        l.pushBoolean(intensity > 0);
        l.pushNumber(@floatCast(f64, intensity));
        l.pushNumber(@intToFloat(f64, frames));
        return 3;
    }


    // tx_bind(file)
    pub fn tx_bind(l: *Lua) i32 {
        l.pushBoolean(
            meshbox.tx.bind(
                if (l.isNoneOrNil(1)) 
                    null
                else 
                    std.mem.span(l.checkString(1))
            ) catch unreachable
        );
        return 1;
    }

    // tx_unload(file)
    pub fn tx_unload(l: *Lua) i32 {
        l.pushBoolean(meshbox.tx.unload(std.mem.span(l.checkString(1))));
        return 1;
    }


    // mx_mode(mode) -- "projection", "model" or "view"
    pub fn mx_mode(l: *Lua) i32 {
        var mode = l.checkOption(meshbox.mx.Modes, 1, .model);
        meshbox.mx.mode(mode);
        return 0;
    }

    // mx_identity()
    pub fn mx_identity(_: *Lua) i32 {
        meshbox.mx.identity();
        return 0;
    }

    // [INTERNAL]
    fn fetch_matrix(l: *Lua) meshbox.mx.Matrix {
        var out: meshbox.mx.Matrix = meshbox.mx.matrix_identity;
        
        l.setTop(1);
        l.checkType(1, .table);
        var len = l.rawLen(1);

        var i: usize = 1;
        while (i <= len) {
            _ = l.rawGetIndex(1, @intCast(c_longlong, i));
            var t = l.getTop();
            out[i-1] = @floatCast(f32, l.checkNumber(t));

            i += 1;
        }

        return out;
    }

    // mx_set(matrix) -- (16 floats in array)
    pub fn mx_set(l: *Lua) i32 {
        meshbox.mx.set(fetch_matrix(l));
        return 0;
    }

    // local matrix = mx_get()
    pub fn mx_get(l: *Lua) i32 {
        l.newTable();

        var out = meshbox.mx.get();
        for (out) | e, k | {
            l.pushNumber(@intToFloat(f64, k)+1);
            l.pushNumber(@floatCast(f64, e));
            l.rawSetTable(-3);
        }

        l.pushString("n");
        l.pushNumber(16);
        l.rawSetTable(-3);

        return 1;
    }

    // mx_perspective(fov, near, far)
    pub fn mx_perspective(l: *Lua) i32 {
        meshbox.mx.perspective(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3))
        );
        return 0;
    }

    // mx_orthographic(near, far)
    pub fn mx_orthographic(l: *Lua) i32 {
        meshbox.mx.orthographic(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2))
        );
        return 0;
    }

    // mx_look_at(eye_x, eye_y, eye_z,   target_x, target_y, target_z,   up_x, up_y, up_z)
    pub fn mx_look_at(l: *Lua) i32 {
        meshbox.mx.look_at(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3)),

            @floatCast(f32, l.checkNumber(4)),
            @floatCast(f32, l.checkNumber(5)),
            @floatCast(f32, l.checkNumber(6)),

            @floatCast(f32, l.checkNumber(7)),
            @floatCast(f32, l.checkNumber(8)),
            @floatCast(f32, l.checkNumber(9))
        );
        return 0;
    }

    // mx_multiply(matrix) -- (16 floats in array)
    pub fn mx_multiply(l: *Lua) i32 {
        var matrix = fetch_matrix(l);
        meshbox.mx.multiply(matrix);
        return 0;
    }

    // mx_translate(x, y, z)
    pub fn mx_translate(l: *Lua) i32 {
        meshbox.mx.translate(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3))
        );
        return 0;
    }

    // mx_rotate(angle, x, y, z)
    pub fn mx_rotate(l: *Lua) i32 {
        meshbox.mx.rotate(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3)),
            @floatCast(f32, l.checkNumber(4))
        );
        return 0;
    }

    // mx_euler(x, y, z)
    pub fn mx_euler(l: *Lua) i32 {
        meshbox.mx.euler(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3))
        );
        return 0;
    }

    // mx_scale(x, y, z)
    pub fn mx_scale(l: *Lua) i32 {
        meshbox.mx.scale(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3))
        );
        return 0;
    }


    // local vertices, indices = vx_load(file)
    pub fn vx_load(l: *Lua) i32 {
        var file = std.mem.span(l.checkString(1));
        var model = (meshbox.vx.load(file) catch unreachable) orelse {
            l.pushBoolean(false);
            return 1;
        };

        l.newTable();
        for (model.vertices) | vertex, vk | {
            l.newTable();

            const fields = std.meta.fields(meshbox.Vertex);
            inline for (fields) | field | {
                l.pushNumber(@field(vertex, field.name));
                l.setField(-2, field.name[0.. :0]);
            }

            l.rawSetIndex(-2, @intCast(i32, vk)+1);
        }

        l.newTable();
        for (model.indices) | index, k | {
            l.pushInteger(index);
            l.rawSetIndex(-2, @intCast(i32, k+1));
        }

        return 2;
    }

    // vx_normal(normal_x, normal_y, normal_z)
    pub fn vx_normal(l: *Lua) i32 {
        meshbox.vx.normal(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3))
        );
        return 0;
    }

    // vx_texcoord(u, v)
    pub fn vx_texcoord(l: *Lua) i32 {
        meshbox.vx.texcoord(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2))
        );
        return 0;
    }

    // vx_color(r, g, b, a) -- Range is 0 to 1, with decimals
    pub fn vx_color(l: *Lua) i32 {
        meshbox.vx.color(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3)),
            @floatCast(f32, l.checkNumber(4))
        );
        return 0;
    }

    // vx_vertex(x, y, z)
    pub fn vx_vertex(l: *Lua) i32 {
        meshbox.vx.vertex(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3))
        ) catch unreachable;
        return 0;
    }

    // vx_mesh({vertex, ...})
    pub fn vx_mesh(l: *Lua) i32 {
        l.setTop(1);
        l.checkType(1, .table);

        var len = l.rawLen(1);
        var vertices = meshbox.allocator.alloc(meshbox.Vertex, @intCast(usize, len)) catch unreachable;

        // TODO: Automate this process with comptime logic
        for (vertices) | *out, i | {		
            _ = l.rawGetIndex(1, @intCast(i32, i+1));
            var t = lua.getTop();

            out .* = .{};

            inline for (comptime std.meta.fields(meshbox.Vertex)) | field | {
                _ = l.getField(t, field.name[0..field.name.len :0]);
                if (!l.isNoneOrNil(-1))
                    @field(out.*, field.name) = @floatCast(f32, l.checkNumber(-1));
                l.pop(1);
            }
        }

        meshbox.vx.mesh(vertices) catch unreachable;
        meshbox.allocator.free(vertices);
        return 0;
    }

    // vx_render()
    // vx_render({index, ...})
    pub fn vx_render(l: *Lua) i32 {
        l.setTop(1);

        if (l.isNoneOrNil(1)) {
            meshbox.vx.render(null) catch unreachable;
            return 0;
        }

        l.checkType(1, .table);
        var len = l.rawLen(1);

        var indices = meshbox.allocator.alloc(u16, @intCast(usize, len)) catch unreachable;

        for (indices) | *out, i | {		
            _ = l.rawGetIndex(1, @intCast(i32, i+1));
            var t = l.getTop();
            out.* = @intCast(u16, l.checkInteger(t));
        }

        meshbox.vx.render(indices) catch unreachable;
        meshbox.allocator.free(indices);
        return 0;
    }

    
    // gx_scissor(x, y, w, h)
    // gx_scissor()
    // gx_scissor(nil)
    pub fn gx_scissor(l: *Lua) i32 {
        meshbox.gx.scissor(
            if (l.isNoneOrNil(1)) 
                null
            else
                meshbox.Rectangle {
                    .x = @floatToInt(u32, l.checkNumber(1)),
                    .y = @floatToInt(u32, l.checkNumber(2)),
                    .w = @floatToInt(u32, l.checkNumber(3)),
                    .h = @floatToInt(u32, l.checkNumber(4))
                }
        );       

        return 0; 
    }

    // gx_viewport(x, y, w, h)
    // gx_viewport()
    // gx_viewport(nil)
    pub fn gx_viewport(l: *Lua) i32 {
        meshbox.gx.viewport(
            if (l.isNoneOrNil(1)) 
                null
            else
                meshbox.Rectangle {
                    .x = @floatToInt(u32, l.checkNumber(1)),
                    .y = @floatToInt(u32, l.checkNumber(2)),
                    .w = @floatToInt(u32, l.checkNumber(3)),
                    .h = @floatToInt(u32, l.checkNumber(4))
                }
        );       

        return 0; 
    }

    // local width = gx_width()
    pub fn gx_width(l: *Lua) i32 {
        l.pushNumber(@intToFloat(f64, meshbox.gx.width()));     

        return 1; 
    }

    // local height = gx_height()
    pub fn gx_height(l: *Lua) i32 {
        l.pushNumber(@intToFloat(f64, meshbox.gx.width()));     

        return 1; 
    }

    // gx_background(r, g, b, a)
    pub fn gx_background(l: *Lua) i32 {
        meshbox.gx.background(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3)),
            @floatCast(f32, l.checkNumber(4))
        );

        return 0; 
    }


    // li_ambient(r, g, b, a)
    pub fn li_ambient(l: *Lua) i32 {
        meshbox.li.ambient(
            @floatCast(f32, l.checkNumber(1)),
            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3)),
            @floatCast(f32, l.checkNumber(4))
        );

        return 0; 
    }

    // li_clear()
    pub fn li_clear(_: *Lua) i32 {
        meshbox.li.clear();
        return 0; 
    }

    // li_light(type, x, y, z, r, g, b) -- type is "directional" or "point"
    pub fn li_light(l: *Lua) i32 {
        meshbox.li.light(
            l.checkOption(meshbox.li.LightType, 1, .point),

            @floatCast(f32, l.checkNumber(2)),
            @floatCast(f32, l.checkNumber(3)),
            @floatCast(f32, l.checkNumber(4)),

            @floatCast(f32, l.checkNumber(5)),
            @floatCast(f32, l.checkNumber(6)),
            @floatCast(f32, l.checkNumber(7))
        );

        return 0; 
    }
};

const to_cstr = std.cstr.addNullByte;

fn load_libraries(allocator: std.mem.Allocator) !void {
    inline for (comptime std.meta.declarations(lua_fn)) | reg | {
        if (!reg.is_pub) continue;

        lua.pushFunction(ziglua.wrap(@field(lua_fn, reg.name)));
        lua.setGlobal(try to_cstr(allocator, reg.name));
    }
}

var lua: Lua = undefined;
pub fn init(allocator: std.mem.Allocator, skip_intro: bool, no_game: bool) !void {
    lua = try Lua.init(allocator);
    lua.open(.{
        .base = true,
        .coroutine = true,
        .package = true,
        .string = true,
        .utf8 = true,
        .table = true,
        .math = true,
        .debug = true,
    });

    try load_libraries(allocator);

    lua.pushBoolean(skip_intro);
    lua.setGlobal("__MB_FLAG_SKIP_INTRO");

    lua.pushBoolean(no_game);
    lua.setGlobal("__MB_FLAG_NO_GAME");

    var stdout = std.io.getStdOut().writer();
    lua.loadString(@embedFile("boot.lua")) catch {
        try stdout.print("{s}\n", .{lua.toString(-1) catch unreachable});
        lua.pop(1);
    };

    // Execute a line of Lua code
    lua.protectedCall(0, 0, 0) catch {
        try stdout.print("{s}\n", .{lua.toString(-1) catch unreachable});
        lua.pop(1);
    };
}

pub fn frame(delta: f64) !void {
    var stdout = std.io.getStdOut().writer();

    try lua.getGlobal("mb_frame");
    lua.pushNumber(delta);
    lua.protectedCall(1, 0, 0) catch {
        try stdout.print("{s}\n", .{lua.toString(-1) catch unreachable});
        lua.pop(1);
    };
}