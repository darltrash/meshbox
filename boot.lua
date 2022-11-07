table.insert(package.searchers, function(t)
   local modulepath = string.gsub(t, "%.", "/")..'.lua'
   local f, s = fs_read(modulepath)
   if s > 0 then
       return assert(load(f, t))
   end
   return ("Unable to load '%s'"):format(t)
end)

local ok = pcall(require, "meshbox")
if ok then return end

-- Splash goes here!

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

local t = 0
cb_frame = function(dt)
    t = t + dt

    mx_mode("projection")
    mx_perspective(80, 0, 1000)

    mx_mode("view")
    mx_look_at(
        3, 0, 2,
        0, 0, 0,
        0, 0, 1
    )

    mx_mode("model")
    mx_euler(t, 0, 0)

    vx_load(cube)
    vx_render(cube.indices)
end