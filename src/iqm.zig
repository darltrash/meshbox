// iqm.zig: A simple (and incomplete) IQM importer written in Zig

// zlib License
// 
// (C) 2022 Nelson "darltrash" Lopez
// 
// This software is provided 'as-is', without any express or implied
// warranty.  In no event will the authors be held liable for any damages
// arising from the use of this software.
// 
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it
// freely, subject to the following restrictions:
// 
// 1. The origin of this software must not be misrepresented; you must not
//    claim that you wrote the original software. If you use this software
//    in a product, an acknowledgment in the product documentation would be
//    appreciated but is not required.
// 2. Altered source versions must be plainly marked as such, and must not be
//    misrepresented as being the original software.
// 3. This notice may not be removed or altered from any source distribution.

const std = @import("std");
const log = std.log.scoped(.iqm);
const json = std.json;
const mem = std.mem;

pub const VertexArrayType = enum(c_int) {
    position = 0, texcoord, normal, tangent, 
    blendindices, blendweights, color
};

pub const VertexArray = extern struct {
    type_: VertexArrayType,
    flags: u32,
    format: c_int,
    size: u32,
    offset: u32
};

pub const RawMesh = extern struct {
    name: u32,
    material: u32,
    first_vertex: u32,
    num_vertices: u32,
    first_triangle: u32,
    num_triangles: u32
};

const Mesh = struct {
    name: []const u8,
    material: []const u8,

    vertex_count: u32,
    vertex_offset: u32,

    triangle_count: u32,
    triangle_offset: u32
};

pub const EXMLight = struct {
    name: []u8,
    type: []u8,
    position: [3]f32,
    color: [4]f32,
    transform: [4*4]f32, 
    power: f32,
    specular: f32
};

pub const EXMData = struct {
    lights: []EXMLight
};

pub const Model = struct {
    header: Header,
    meshes: []Mesh,

    indices:   []u32,
    vertices:  usize,

    positions: []f32,
    texcoords: []f32,
    normals:   []f32,
    tangents:  []f32,

    blend_indices: []u8,
    blend_weights: []u8,
    color:         []u8,

    exm_data: ?EXMData = null
};

pub const Header = extern struct {
    magic: [16]u8,    // 0
    version: c_uint,  // 16
    filesize: c_uint, // 20
    flags: c_uint,    // 24

    num_text: c_uint, // 28 
    ofs_text: c_uint, // 32

    num_meshes: c_uint, // 36
    ofs_meshes: c_uint, // 40

    num_vertexarrays: c_uint, // 44
    num_vertexes: c_uint,     // 48
    ofs_vertexarrays: c_uint, // 52

    num_triangles: c_uint, // 56
    ofs_triangles: c_uint, // 60
    ofs_adjacency: c_uint, // 64

    num_joints: c_uint, 
    ofs_joints: c_uint,

    num_poses: c_uint, 
    ofs_poses: c_uint,
    
    num_anims: c_uint, 
    ofs_anims: c_uint,

    num_frames: c_uint, 
    num_framechannels: c_uint, 
    ofs_frames: c_uint, 
    ofs_bounds: c_uint,

    num_comment: c_uint, 
    ofs_comment: c_uint,

    num_extensions: c_uint, 
    ofs_extensions: c_uint
};

fn grab(data: []const u8, where: usize, comptime T: type) T {
    var raw = data[where..][0..@sizeOf(T)];
    return @bitCast(T, raw.*);
}

fn grabString(data: []const u8, where: usize) []const u8 {
    const str = @ptrCast([*c]const u8, data.ptr+where);
    return str[0..std.mem.len(str)];
}

pub fn fromBuffer(data: []const u8, isEXM: bool, alloc: mem.Allocator) !Model {
    // I am sorry big endian friends :(
    comptime if (@import("builtin").target.cpu.arch.endian() == .Big)
        return error.UnsupportedEndian;

    ////// HANDLE HEADER //////////
    var header = grab(data, 0, Header);

    // Check if the file is a correct iqm model.
    if (!mem.eql(u8, &header.magic, "INTERQUAKEMODEL\x00")) 
        return error.IncorrectHeader;
    
    // Only version 2 supported.
    if (header.version != 2)
        return error.IncorrectVersion;


    // TODO: Handle animations!

    ////// HANDLE VERTEX ARRAYS //////////
    var va_idx: usize = 0;
    var va_max = @intCast(usize, header.num_vertexarrays);
    var va_off = @intCast(usize, header.ofs_vertexarrays);
    var vx_max = @intCast(usize, header.num_vertexes);

    var va_position      = try alloc.alloc(f32, vx_max*3);
    var va_texcoord      = try alloc.alloc(f32, vx_max*2);
    var va_normal        = try alloc.alloc(f32, vx_max*3);
    var va_tangent       = try alloc.alloc(f32, vx_max*4);
    var va_blend_indices = try alloc.alloc(u8,  vx_max*4);
    var va_blend_weights = try alloc.alloc(u8,  vx_max*4);
    var va_color         = try alloc.alloc(u8,  vx_max*4);

    while (va_idx < va_max) {
        var va_current = grab(data, va_off + (va_idx*@sizeOf(VertexArray)), VertexArray);
        
        switch (va_current.type_) {
            .position => @memcpy(@ptrCast([*]u8, va_position.ptr), data[va_current.offset..va_current.offset+(vx_max*3)].ptr, @sizeOf(f32)*vx_max*3),
            .texcoord => @memcpy(@ptrCast([*]u8, va_texcoord.ptr), data[va_current.offset..va_current.offset+(vx_max*2)].ptr, @sizeOf(f32)*vx_max*2),
            .normal   => @memcpy(@ptrCast([*]u8, va_normal  .ptr), data[va_current.offset..va_current.offset+(vx_max*3)].ptr, @sizeOf(f32)*vx_max*3),
            .tangent  => @memcpy(@ptrCast([*]u8, va_tangent .ptr), data[va_current.offset..va_current.offset+(vx_max*4)].ptr, @sizeOf(f32)*vx_max*4),

            .blendindices => mem.copy(u8, va_blend_indices,  data[va_current.offset..va_current.offset+(vx_max*4)]),
            .blendweights => mem.copy(u8, va_blend_weights,  data[va_current.offset..va_current.offset+(vx_max*4)]),
            .color        => mem.copy(u8, va_color,          data[va_current.offset..va_current.offset+(vx_max*4)])
        }

        va_idx += 1;
    }

    ////// HANDLE TRIANGLES //////////
    var tr_idx: usize = 0;
    var tr_max = @intCast(usize, header.num_triangles);
    var tr_off = @intCast(usize, header.ofs_triangles);
    var indices = try alloc.alloc(u32, tr_max*3);

    while (tr_idx < tr_max) {
        var triangle = grab(data, tr_off+(tr_idx*@sizeOf([3]u32)), [3]u32);
        indices[(tr_idx*3)+0] = @intCast(u32, triangle[0]);
        indices[(tr_idx*3)+1] = @intCast(u32, triangle[1]);
        indices[(tr_idx*3)+2] = @intCast(u32, triangle[2]);
        tr_idx += 1;
    }

    ////// HANDLE MESHES ////////// 
    var me_idx: usize = 0;
    var me_max = @intCast(usize, header.num_meshes);
    var me_off = @intCast(usize, header.ofs_meshes);
    var meshes = try alloc.alloc(Mesh, me_max);
    while (me_idx < me_max) {
        var mesh = grab(data, me_off+(me_idx*@sizeOf(RawMesh)), RawMesh);

        meshes[me_idx] = Mesh {
            .name = grabString(data, header.ofs_text+mesh.name),
            .material = grabString(data, header.ofs_text+mesh.material),

            .vertex_count = mesh.num_vertices,
            .vertex_offset = mesh.first_vertex,
            .triangle_count = mesh.num_triangles,
            .triangle_offset = mesh.first_triangle
        };

        me_idx += 1;
    }

    _ = isEXM;
    //if (isEXM) {
    //    var str = grabString(data, header.ofs_comment);
    //    if (str.len > 0) {
    //        var stream = json.TokenStream.init(str);
    //        var res = try json.parse(EXMData, &stream, .{ 
    //            .allocator = alloc,
    //            .ignore_unknown_fields = true 
    //        });
    //
    //        log.info("{any}", .{res});
    //    }
    //}

    var out = Model { 
        .header = header,
        .meshes = meshes,

        .indices = indices,
        .vertices = @intCast(usize, header.num_vertexes),

        .positions = va_position,
        .texcoords = va_texcoord,
        .normals   = va_normal,
        .tangents  = va_tangent,

        .blend_indices = va_blend_indices,
        .blend_weights = va_blend_weights,
        .color         = va_color
    };

    return out;
}

pub fn fromFile(name: []const u8, isEXM: ?bool, alloc: mem.Allocator) !Model {
    var file = try std.fs.cwd().openFile(name, .{ .read = true });
    defer file.close();

    var raw = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return try fromBuffer(raw, isEXM orelse mem.endsWith(u8, name, ".exm"), alloc);
}
