require = function (t)
    local modulepath = t:gsub("%.", "/")..'.lua'
    local f = fs_read(modulepath)
    if f then
        return assert(load(f))()
    end
    error("module '"..t.."' not found")
end

local cube = {
    {x= 1, y= 1, z= 1, u=0.066, v=0.219},
    {x=-1, y=-1, z= 1, u=0.000, v=0.109},
    {x=-1, y= 1, z= 1, u=0.003, v=0.219},
    {x= 1, y=-1, z= 1, u=0.062, v=0.109},
    {x= 1, y=-1, z=-1, u=0.062, v=0.102},
    {x=-1, y=-1, z= 1, u=0.000, v=0.000},
    {x= 1, y=-1, z= 1, u=0.062, v=0.000},
    {x=-1, y=-1, z=-1, u=0.000, v=0.102},
    {x=-1, y=-1, z=-1, u=0.187, v=0.102},
    {x=-1, y= 1, z= 1, u=0.125, v=0.000},
    {x=-1, y=-1, z= 1, u=0.187, v=0.000},
    {x=-1, y= 1, z=-1, u=0.125, v=0.102},
    {x=-1, y= 1, z=-1, u=0.062, v=0.219},
    {x= 1, y=-1, z=-1, u=0.125, v=0.109},
    {x= 1, y= 1, z=-1, u=0.125, v=0.219},
    {x=-1, y=-1, z=-1, u=0.062, v=0.109},
    {x= 1, y= 1, z=-1, u=0.250, v=0.102},
    {x= 1, y=-1, z= 1, u=0.187, v=0.000},
    {x= 1, y= 1, z= 1, u=0.250, v=0.000},
    {x= 1, y=-1, z=-1, u=0.187, v=0.102},
    {x=-1, y= 1, z=-1, u=0.125, v=0.102},
    {x= 1, y= 1, z= 1, u=0.062, v=0.000},
    {x=-1, y= 1, z= 1, u=0.125, v=0.000},
    {x= 1, y= 1, z=-1, u=0.062, v=0.102},
    
    indices = {
        0, 1, 2, 0, 3, 1, 4, 5, 6, 4, 7, 5, 8, 9,
        10, 8, 11, 9, 12, 13, 14, 12, 15, 13, 16,
        17, 18, 16, 19, 17, 20, 21, 22, 20, 23, 21
    }
}

sv_identity("meshbox-bios")

local p = 1

local lerp = function(a, b, t)
    return a * (1-t) + b * t
end

local next_mb_frame = false

local stage = 1
local stages = {
    [1] = function (dt)
        p = lerp(p, 0, dt*2)
        mx_mode("projection")
        mx_perspective(100, 0, 1000)

        local e = (p * 1)
        mx_mode("view")
        mx_look_at(
            math.sin(e)*5, math.cos(e)*5, p*10,
            0, 0, 0,
            0, 0, 1
        )
        
        local i = 1 - p
        mx_mode("model")
        mx_translate(0, 0, p*10)
        mx_scale(i * 1.1, i * 1.1, i * 1.1)

        -- I feel like meshbox should allow for you
        -- to re-render a mesh, so you dont have to 
        -- upload twice :/
        vx_mesh(cube) 
        vx_render(cube.indices)

        tx_bind("<meshbox>")
        mx_scale(0.9, 0.9, 0.9)
        li_ambient(1, 1, 1, 1)

        vx_mesh(cube)
        vx_render(cube.indices)

        if (p < 0.005) and not __MB_FLAG_NO_GAME then
            p = 1
            stage = 2
        end
    end,

    [2] = function (dt)
        p = lerp(p, 0, dt*3)
        mx_mode("projection")
        mx_perspective(100, 0, 1000)

        mx_mode("view")
        mx_look_at(
            0, 5, 0,
            0, 0, 0,
            0, 0, 1
        )

        li_ambient(1, 1, 1, p)

        mx_mode("model")
        mx_identity()
        mx_euler(0, 1-p, 0)
        mx_scale(p*1.1, p*1.1, p*1.1)

        vx_mesh(cube) 
        vx_render(cube.indices)

        tx_bind("<meshbox>")
        mx_scale(0.9, 0.9, 0.9)
        vx_mesh(cube)
        vx_render(cube.indices)

        if (p < 0.01) then
            require("meshbox")
        end
    end
}

function mb_error(err, traceback, dt)
    print(err, traceback)
end

local function wrap(fn, ...)
    local status, err = pcall(fn, ...)

    if not status then
        function mb_frame(dt)
            mb_error(err, debug.traceback(), dt)
        end
    end
end

function mb_frame(dt)
    local k = mb_loop or stages[stage]

    local status, err = wrap(k, dt)
end

--d