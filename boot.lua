table.insert(package.searchers, function(t)
   local modulepath = string.gsub(t, "%.", "/")..'.lua'
   local f, s = fs_read(modulepath)
   if s > 0 then
       return assert(load(f, t))
   end
   return ("Unable to load '%s'"):format(t)
end)

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

local lerp = function (a, b, t)
    return a * (1-t) + b * t
end

local t = 0
local c = 100
local c2 = 100
local game_loaded
local new_cb_frame
local toggle1 = true

cb_frame = function (dt)
    t = t + dt

    local w = gx_width()
    local h = gx_height()
    local res = math.min(w, h)

    if game_loaded then
        if c2 < 0.08 then
            sv_identity()
            cb_frame = new_cb_frame
            cb_setup()
        end

        local r = res * (c2/100)

        gx_viewport((w/2)-(r/2), (h/2)-(r/2), r, r)
        gx_ambient(1, 1, 1, c2/100)
    else
        gx_viewport((c2/100)*((w/2)-(res/2)), (h/2)-(res/2), res, res)
    end

    gx_background(0.086, 0.086, 0.105, 1)

    mx_mode("projection")
    mx_perspective(80, 0, 1000)

    mx_mode("view")
    mx_look_at(
        4+c, 0, 2+(c/4),
        0, 0, 0,
        0, 0, 1
    )

    c = lerp(c, 0, dt*5)
    if c < 0.01 then
        c2 = lerp(c2, 0, dt*5)
        if toggle1 and not game_loaded then
            wn_title("meshbox - bios.")
            toggle1 = false
        end
    end

    mx_mode("model")
    mx_euler(0, c/30, t)

    vx_load(cube)
    vx_render(cube.indices)
    gx_viewport()
end

cb_setup = function ()
    local of = cb_frame

    cb_setup = function () end
    if pcall(require, "meshbox") then
        game_loaded = true
    end
    new_cb_frame = cb_frame

    cb_frame = of
end

