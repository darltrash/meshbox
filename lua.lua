local t = 0
local cube = {
    {r=1, g=0.0, b=0.0, a=1, x=-1, y=-1, z=-1},
    {r=1, g=0.0, b=0.0, a=1, x= 1, y=-1, z=-1},
    {r=1, g=0.0, b=0.0, a=1, x= 1, y= 1, z=-1},
    {r=1, g=0.0, b=0.0, a=1, x=-1, y= 1, z=-1},
    {r=0, g=1.0, b=0.0, a=1, x=-1, y=-1, z= 1},
    {r=0, g=1.0, b=0.0, a=1, x= 1, y=-1, z= 1},
    {r=0, g=1.0, b=0.0, a=1, x= 1, y= 1, z= 1},
    {r=0, g=1.0, b=0.0, a=1, x=-1, y= 1, z= 1},
    {r=0, g=0.0, b=1.0, a=1, x=-1, y=-1, z=-1},
    {r=0, g=0.0, b=1.0, a=1, x=-1, y= 1, z=-1},
    {r=0, g=0.0, b=1.0, a=1, x=-1, y= 1, z= 1},
    {r=0, g=0.0, b=1.0, a=1, x=-1, y=-1, z= 1},
    {r=1, g=0.5, b=0.0, a=1, x= 1, y=-1, z=-1},
    {r=1, g=0.5, b=0.0, a=1, x= 1, y= 1, z=-1},
    {r=1, g=0.5, b=0.0, a=1, x= 1, y= 1, z= 1},
    {r=1, g=0.5, b=0.0, a=1, x= 1, y=-1, z= 1},
    {r=0, g=0.5, b=1.0, a=1, x=-1, y=-1, z=-1},
    {r=0, g=0.5, b=1.0, a=1, x=-1, y=-1, z= 1},
    {r=0, g=0.5, b=1.0, a=1, x= 1, y=-1, z= 1},
    {r=0, g=0.5, b=1.0, a=1, x= 1, y=-1, z=-1},
    {r=1, g=0.0, b=0.5, a=1, x=-1, y= 1, z=-1},
    {r=1, g=0.0, b=0.5, a=1, x=-1, y= 1, z= 1},
    {r=1, g=0.0, b=0.5, a=1, x= 1, y= 1, z= 1},
    {r=1, g=0.0, b=0.5, a=1, x= 1, y= 1, z=-1},

    indices = {
        0,  1,  2,   0,  2,  3,
        6,  5,  4,   7,  6,  4,
        8,  9,  10,  8,  10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20
    }
}

local normalize = function (x, y, z)
    local l = math.sqrt(x^2 + y^2 + z^2)
    if l == 0 then
        return 0, 0, 0, 0
    end
    return x/l, y/l, z/l, l
end

local cross = function (ax, ay, az, bx, by, bz)
    return
        ay * bz - az * by,
        az * bx - ax * bz,
        ax * by - ay * bx
end

for x=1, #cube.indices, 3 do
    local a = cube[cube.indices[x+0]+1]
    local b = cube[cube.indices[x+1]+1]
    local c = cube[cube.indices[x+2]+1]
    local nx, ny, nz = cross(
        b.x - a.x,
        b.y - a.y,
        b.z - a.z,

        c.x - a.x,
        c.y - a.y,
        c.z - a.z
    )

    a.nx = (a.nx or 0) + nx
    a.ny = (a.ny or 0) + ny
    a.nz = (a.nz or 0) + nz

    b.nx = (b.nx or 0) + nx
    b.ny = (b.ny or 0) + ny
    b.nz = (b.nz or 0) + nz

    c.nx = (c.nx or 0) + nx
    c.ny = (c.ny or 0) + ny
    c.nz = (c.nz or 0) + nz
end

for k, v in ipairs(cube) do
    v.nx, v.ny, v.nz = normalize(v.nx, v.ny, v.nz)
end

local t = 0
function cb_frame(dt)
    t = t + dt

    mx_mode("model")
    mx_translate(0, 0, 1)
    
    vx_load {
        {x=-1, y= 1, z=0,   r=1.0, g=0.6, b=0.8, a=1.0},
        {x= 1, y= 1, z=0,   r=1.0, g=0.6, b=0.8, a=1.0},
        {x= 1, y=-1, z=0,   r=0.2, g=0.5, b=1.0, a=1.0}, -- top
        {x=-1, y=-1, z=0,   r=0.2, g=0.5, b=1.0, a=1.0}  -- top
    }

    vx_render { 0, 1, 2, 0, 2, 3 }

    mx_mode("projection")
    mx_perspective(80, 0, 1000)

    mx_mode("view")
    mx_look_at(
        2, 2, 2,
        0, 0, 0,
        0, 0, 1
    )

    mx_mode("model")
    mx_identity()
    mx_euler(0, 0, t)

    tx_bind("sungpung.png")
    vx_load {
        {x=-1, y= 1, z=0,   u=0, v=1},
        {x= 1, y= 1, z=0,   u=1, v=1},
        {x= 1, y=-1, z=0,   u=1, v=0},
        {x=-1, y=-1, z=0,   u=0, v=0}
    }
    vx_render { 0, 1, 2, 0, 2, 3 }

    --local x, y   = math.cos(t)*2,         math.sin(t)*-2
    --local x2, y2 = math.cos(t+math.pi)*2, math.sin(t+math.pi)*-2
--
    --gx_ambient(0.6, 0.5, 0.8, 1)
    --mx_identity()
    --mx_translate(x, y, 0)
    --mx_scale(0.25, 0.25, 0.25)
    --vx_load(cube)
    --vx_render(cube.indices)
--
    --gx_ambient(0.8, 0.5, 0.6, 1)
    --mx_identity()
    --mx_translate(x2, y2, 0)
    --mx_scale(0.25, 0.25, 0.25)
    --vx_load(cube)
    --vx_render(cube.indices)
--
    --mx_identity()
    --mx_euler(0, t, 0)
    --mx_scale(0.5, 0.5, 0.5)
    --gx_ambient(0.2, 0.2, 0.3, 1)
    --gx_light("point", x, y,   0, 10.8, 1.2, 1.9)
    --gx_light("point", x2, y2, 0, 10.9, 1.2, 1.8)
    --vx_load(cube)
    --vx_render(cube.indices)

    --gx_background(1, 1, 1, 1)
end