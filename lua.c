#include <stdlib.h>
#include "lib/minilua.h"
#include "meshbox.h"
#include "lib/log.h"

lua_State *l;

void lua_api_none() {}

int lua_api_in_joystick() {
    vec2 o = in_joystick(luaL_checkinteger(l, 1));
    lua_pushnumber(l, o.x);
    lua_pushnumber(l, o.y);
    return 2;
}

int lua_api_in_button() {
    int b = in_button(luaL_checkinteger(l, 1));
    lua_pushboolean(l, b);
    lua_pushnumber(l, b);
    return 2;
}

void lua_api_tx_bind() {
    if (lua_isnoneornil(l, 1))
        return tx_bind(NULL);

    tx_bind(luaL_checkstring(l, 1));
}

void lua_api_mx_mode() {
    int option = luaL_checkoption(l, 1, "projection", 
        (const char *const []) {
            "model", "view", "projection", NULL
        }
    );
    
    if (mx_mode(option+1)) {
        luaL_error(l, "Wrong matrix mode!");
    }
}

void lua_api_mx_identity() {
    mx_identity();
}

void lua_api_mx_set() {
    matrix o = matrix_identity;

    lua_settop(l, 1);
    luaL_checktype(l, 1, LUA_TTABLE);
    int len = lua_rawlen(l, 1);

    for (int i=1; i<=len; i++)
    {		
        lua_rawgeti(l, 1, i);
        int t = lua_gettop(l);
        o.data[i-1] = luaL_checknumber(l, t);
    }

    mx_set(o);
}

int lua_api_mx_get() {
    lua_newtable(l);
    
    matrix o = mx_get();
    for (int i=0; i < 16; i++) { 
        lua_pushnumber(l, i+1);
        lua_pushnumber(l, o.data[i]);
        lua_rawset(l, -3);
    }

    lua_pushliteral(l, "n");
    lua_pushnumber(l, 16);
    lua_rawset(l, -3);

    return 1;
}

void lua_api_mx_perspective() {
    mx_perspective(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3)
    );
}

void lua_api_mx_orthographic() {
    mx_orthographic(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2)
    );
}

void lua_api_mx_look_at() {
    mx_look_at(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),

        luaL_checknumber(l, 4),
        luaL_checknumber(l, 5),
        luaL_checknumber(l, 6),

        luaL_checknumber(l, 7),
        luaL_checknumber(l, 8),
        luaL_checknumber(l, 9)
    );
}

void lua_api_mx_multiply() {
    matrix o = matrix_identity;

    lua_settop(l, 1);
    luaL_checktype(l, 1, LUA_TTABLE);
    int len = lua_rawlen(l, 1);

    for (int i=1; i<=len; i++)
    {		
        lua_rawgeti(l, 1, i);
        int t = lua_gettop(l);
        o.data[i-1] = luaL_checknumber(l, t);
    }

    mx_multiply(o);
}

void lua_api_mx_translate() {
    mx_translate(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3)
    );
}

void lua_api_mx_rotate() {
    mx_rotate(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),
        luaL_checknumber(l, 4)
    );
}

void lua_api_mx_euler() {
    mx_euler(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3)
    );
}

void lua_api_mx_scale() {
    mx_scale(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3)
    );
}

void lua_api_vx_normal() {
    vx_normal(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3)
    );
}

void lua_api_vx_texcoord() {
    vx_texcoord(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2)
    );
}

void lua_api_vx_color() {
    vx_color(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),
        luaL_checknumber(l, 4)
    );
}

void lua_api_vx_vertex() { // number, number, [number]
    double x = 0.0f;
    double y = 0.0f;
    double z = 0.0f;

    x = luaL_checknumber(l, 1);
    y = luaL_checknumber(l, 2);

    if (!lua_isnoneornil(l, 3))
        z = luaL_checknumber(l, 3);

    vx_vertex(x, y, z);
}

void lua_api_vx_load() { // {vertex{}, ...}
    matrix o = matrix_identity;

    lua_settop(l, 1);
    luaL_checktype(l, 1, LUA_TTABLE);
    int len = lua_rawlen(l, 1);

    vertex vertices[len];

    for (int i=1; i<=len; i++)
    {		
        lua_rawgeti(l, 1, i);
        int t = lua_gettop(l);

        vertices[i-1] = vertex_default;

        // Position
        lua_getfield(l, t, "x");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].x = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "y");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].y = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "z");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].z = lua_tonumber(l, -1);
        lua_pop(l, 1);

        // Normals
        lua_getfield(l, t, "nx");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].nx = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "ny");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].ny = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "nz");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].nz = lua_tonumber(l, -1);
        lua_pop(l, 1);

        // TexCoords
        lua_getfield(l, t, "u");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].u = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "v");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].v = lua_tonumber(l, -1);
        lua_pop(l, 1);

        // Color
        lua_getfield(l, t, "r");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].r = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "g");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].g = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "b");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].b = lua_tonumber(l, -1);
        lua_pop(l, 1);

        lua_getfield(l, t, "a");
        if (!lua_isnoneornil(l, -1))
            vertices[i-1].a = lua_tonumber(l, -1);
        lua_pop(l, 1);
    }

    vx_load(vertices, len);
}

void lua_api_vx_render() { // [{number, ...}]
    lua_settop(l, 1);
    if (lua_isnoneornil(l, 1))
        return vx_render(NULL, 0);

    luaL_checktype(l, 1, LUA_TTABLE);
    int len = lua_rawlen(l, 1);

    uint32_t indices[len];

    for (int i=1; i<=len; i++)
    {		
        lua_rawgeti(l, 1, i);
        int t = lua_gettop(l);
        indices[i-1] = luaL_checkinteger(l, t);
    }

    vx_render(indices, len);
}

void lua_api_gx_scissor() {
    if (lua_isnoneornil(l, 1)) 
        return gx_scissor(0, 0, gx_width(), gx_height());

    gx_scissor(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),
        luaL_checknumber(l, 4)
    );
}

void lua_api_gx_viewport() {
    if (lua_isnoneornil(l, 1)) 
        return gx_viewport(0, 0, gx_width(), gx_height());

    gx_viewport(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),
        luaL_checknumber(l, 4)
    );
}

int lua_api_gx_width() {
    lua_pushnumber(l, gx_width());
    return 1;
}

int lua_api_gx_height() {
    lua_pushnumber(l, gx_height());
    return 1;
}

void lua_api_gx_background() {
    if (lua_isnoneornil(l, 1)) 
        return gx_background(1, 1, 1, 1);

    gx_background(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),
        luaL_checknumber(l, 4)
    );
}

void lua_api_gx_ambient() {
    if (lua_isnoneornil(l, 1)) 
        return gx_ambient(1, 1, 1, 1);

    gx_ambient(
        luaL_checknumber(l, 1),
        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),
        luaL_checknumber(l, 4)
    );
}

void lua_api_gx_clear() {
    gx_clear();
}

void lua_api_gx_light() {
    int type = luaL_checkoption(l, 1, "directional", 
        (const char *const []) {
            "directional", "point", NULL
        }
    );

    gx_light (
        type+1, 

        luaL_checknumber(l, 2),
        luaL_checknumber(l, 3),
        luaL_checknumber(l, 4),

        luaL_checknumber(l, 5),
        luaL_checknumber(l, 6),
        luaL_checknumber(l, 7)
    );
}

struct { 
    char *name; 
    void *fn;

} registers[] = {
    {"cb_setup",    lua_api_none},
    {"cb_frame",    lua_api_none},

    {"in_joystick", lua_api_in_joystick},
    {"in_button",   lua_api_in_button},

    {"tx_bind",     lua_api_tx_bind},

    {"mx_mode",     lua_api_mx_mode},
    {"mx_identity", lua_api_mx_identity},
    {"mx_set",      lua_api_mx_set},
    {"mx_get",      lua_api_mx_get},
    {"mx_perspective",  lua_api_mx_perspective},
    {"mx_orthographic", lua_api_mx_orthographic},
    {"mx_look_at",   lua_api_mx_look_at},
    {"mx_multiply",  lua_api_mx_multiply},
    {"mx_translate", lua_api_mx_translate},
    {"mx_rotate",    lua_api_mx_rotate},
    {"mx_euler",     lua_api_mx_euler},
    {"mx_scale",     lua_api_mx_scale},

    {"vx_normal",   lua_api_vx_normal},
    {"vx_texcoord", lua_api_vx_texcoord},
    {"vx_color",    lua_api_vx_color},
    {"vx_vertex",   lua_api_vx_vertex},
    {"vx_load",     lua_api_vx_load},
    {"vx_render",   lua_api_vx_render},

    {"gx_scissor",    lua_api_gx_scissor},
    {"gx_viewport",   lua_api_gx_viewport},
    {"gx_width",      lua_api_gx_width},
    {"gx_height",     lua_api_gx_height},
    {"gx_background", lua_api_gx_background},
    {"gx_ambient",    lua_api_gx_ambient},
    {"gx_clear",      lua_api_gx_clear},
    {"gx_light",      lua_api_gx_light},

    {NULL, NULL}
};

int lua_api_setup() {
    log_info("Loading Lua.");

    l = luaL_newstate();
    luaL_openlibs(l);

    int i = 0;
    while (1) {    
        if (registers[i].name == NULL)
            break;

        lua_pushcfunction(l, registers[i].fn);
        lua_setglobal(l, registers[i].name);
        i++;
    }

    luaL_dostring(l, "require 'lua'");

    lua_getglobal(l, "cb_setup");
    if (lua_pcall(l, 0, 0, 0)) {
        log_fatal("Failed to run cb_setup(): \n>\t%s\n", lua_tostring(l, -1));
        exit(1);
    };

    return 1;
}

void lua_api_frame(double delta) {
    lua_getglobal(l, "cb_frame");
    lua_pushnumber(l, delta);
    if (lua_pcall(l, 1, 0, 0)) {
        log_fatal("Failed to run cb_frame(): \n>\t%s\n", lua_tostring(l, -1));
        exit(1);
    };
}