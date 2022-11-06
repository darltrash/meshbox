local cube = {
    {x=-1, y=-1, z=-1,   nx= 0, ny= 0, nz= 1,   r=1.0, g=0.0, b=0.0},
    {x= 1, y=-1, z=-1,   nx= 0, ny= 0, nz= 1,   r=1.0, g=0.0, b=0.0},
    {x= 1, y= 1, z=-1,   nx= 0, ny= 0, nz= 1,   r=1.0, g=0.0, b=0.0},
    {x=-1, y= 1, z=-1,   nx= 0, ny= 0, nz= 1,   r=1.0, g=0.0, b=0.0},
    {x=-1, y=-1, z= 1,   nx= 0, ny= 0, nz=-1,   r=0.0, g=1.0, b=0.0},
    {x= 1, y=-1, z= 1,   nx= 0, ny= 0, nz=-1,   r=0.0, g=1.0, b=0.0},
    {x= 1, y= 1, z= 1,   nx= 0, ny= 0, nz=-1,   r=0.0, g=1.0, b=0.0},
    {x=-1, y= 1, z= 1,   nx= 0, ny= 0, nz=-1,   r=0.0, g=1.0, b=0.0},
    {x=-1, y=-1, z=-1,   nx= 1, ny= 0, nz= 0,   r=0.0, g=0.0, b=1.0},
    {x=-1, y= 1, z=-1,   nx= 1, ny= 0, nz= 0,   r=0.0, g=0.0, b=1.0},
    {x=-1, y= 1, z= 1,   nx= 1, ny= 0, nz= 0,   r=0.0, g=0.0, b=1.0},
    {x=-1, y=-1, z= 1,   nx= 1, ny= 0, nz= 0,   r=0.0, g=0.0, b=1.0},
    {x= 1, y=-1, z=-1,   nx=-1, ny= 0, nz= 0,   r=1.0, g=0.5, b=0.0},
    {x= 1, y= 1, z=-1,   nx=-1, ny= 0, nz= 0,   r=1.0, g=0.5, b=0.0},
    {x= 1, y= 1, z= 1,   nx=-1, ny= 0, nz= 0,   r=1.0, g=0.5, b=0.0},
    {x= 1, y=-1, z= 1,   nx=-1, ny= 0, nz= 0,   r=1.0, g=0.5, b=0.0},
    {x=-1, y=-1, z=-1,   nx= 0, ny= 1, nz= 0,   r=0.0, g=0.5, b=1.0},
    {x=-1, y=-1, z= 1,   nx= 0, ny= 1, nz= 0,   r=0.0, g=0.5, b=1.0},
    {x= 1, y=-1, z= 1,   nx= 0, ny= 1, nz= 0,   r=0.0, g=0.5, b=1.0},
    {x= 1, y=-1, z=-1,   nx= 0, ny= 1, nz= 0,   r=0.0, g=0.5, b=1.0},
    {x=-1, y= 1, z=-1,   nx= 0, ny=-1, nz= 0,   r=1.0, g=0.0, b=0.5},
    {x=-1, y= 1, z= 1,   nx= 0, ny=-1, nz= 0,   r=1.0, g=0.0, b=0.5},
    {x= 1, y= 1, z= 1,   nx= 0, ny=-1, nz= 0,   r=1.0, g=0.0, b=0.5},
    {x= 1, y= 1, z=-1,   nx= 0, ny=-1, nz= 0,   r=1.0, g=0.0, b=0.5},

    indices = {
        0,  1,  2,   0,  2,  3,
        6,  5,  4,   7,  6,  4,
        8,  9,  10,  8,  10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20
    }
}

for _, v in ipairs(cube) do
    v.r = 1
    v.g = 1
    v.b = 1
end

local t = 0
function cb_frame(dt)
    t = t + dt

    mx_mode("model")
    mx_translate(0, 0, 1)
    
    tx_bind("funky.png")
    vx_load {
        {x=-1, y= 1, z=0,   u=0, v=1,   r=1.0, g=0.6, b=0.8, a=1.0},
        {x= 1, y= 1, z=0,   u=1, v=1,   r=1.0, g=0.6, b=0.8, a=1.0},
        {x= 1, y=-1, z=0,   u=1, v=0,   r=0.2, g=0.5, b=1.0, a=1.0}, -- top
        {x=-1, y=-1, z=0,   u=0, v=0,   r=0.2, g=0.5, b=1.0, a=1.0}  -- top
    }

    vx_render { 0, 1, 2, 0, 2, 3 }
    tx_bind()

    local function magic()
        mx_mode("view")
        mx_look_at(
            0.001, 0, 4,
            0, 0, 0,
            0, 0, 1
        )
    
        mx_mode("model")
        mx_identity()

        local x,  y  = math.cos(t)*2,         math.sin(t)*-2
        local x2, y2 = math.cos(t+math.pi)*2, math.sin(t+math.pi)*-2
    
        mx_translate(x, y, 1)
        mx_scale(0.1, 0.1, 0.1)
        vx_load(cube)
        vx_render(cube.indices)
    
        mx_identity()
        mx_euler(0, 0, t)
        mx_scale(0.5, 0.5, 0.5)
        gx_ambient(0x98/255, 0x8c/255, 0xe6/255, 1)
        gx_light("point",  x, y, 1,    0.9, 0.7, 0.3)
        vx_load(cube)
        vx_render(cube.indices)
    end

    local w = gx_width()

    gx_viewport(0, 0, w/2, 600)
    mx_mode("projection")
    mx_perspective(80, 0, 1000)
    magic()

    gx_ambient()
    gx_clear()
    gx_viewport(w/2, 0, w/2, 600)
    mx_mode("projection")
    mx_perspective(80, 0, 1000)
    magic()
end