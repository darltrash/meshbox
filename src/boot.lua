require = function(t)
    local modulepath = t:gsub("%.", "/") .. '.lua'
    local f = fs_read(modulepath)
    if f then
        return assert(load(f))()
    end
    error("module '" .. t .. "' not found")
end

local cube = {
    { x = 1, y = 1, z = 1, u = 0.066, v = 0.219 },
    { x = -1, y = -1, z = 1, u = 0.000, v = 0.109 },
    { x = -1, y = 1, z = 1, u = 0.003, v = 0.219 },
    { x = 1, y = -1, z = 1, u = 0.062, v = 0.109 },
    { x = 1, y = -1, z = -1, u = 0.062, v = 0.102 },
    { x = -1, y = -1, z = 1, u = 0.000, v = 0.000 },
    { x = 1, y = -1, z = 1, u = 0.062, v = 0.000 },
    { x = -1, y = -1, z = -1, u = 0.000, v = 0.102 },
    { x = -1, y = -1, z = -1, u = 0.187, v = 0.102 },
    { x = -1, y = 1, z = 1, u = 0.125, v = 0.000 },
    { x = -1, y = -1, z = 1, u = 0.187, v = 0.000 },
    { x = -1, y = 1, z = -1, u = 0.125, v = 0.102 },
    { x = -1, y = 1, z = -1, u = 0.062, v = 0.219 },
    { x = 1, y = -1, z = -1, u = 0.125, v = 0.109 },
    { x = 1, y = 1, z = -1, u = 0.125, v = 0.219 },
    { x = -1, y = -1, z = -1, u = 0.062, v = 0.109 },
    { x = 1, y = 1, z = -1, u = 0.250, v = 0.102 },
    { x = 1, y = -1, z = 1, u = 0.187, v = 0.000 },
    { x = 1, y = 1, z = 1, u = 0.250, v = 0.000 },
    { x = 1, y = -1, z = -1, u = 0.187, v = 0.102 },
    { x = -1, y = 1, z = -1, u = 0.125, v = 0.102 },
    { x = 1, y = 1, z = 1, u = 0.062, v = 0.000 },
    { x = -1, y = 1, z = 1, u = 0.125, v = 0.000 },
    { x = 1, y = 1, z = -1, u = 0.062, v = 0.102 },

    indices = {
        0, 1, 2, 0, 3, 1, 4, 5, 6, 4, 7, 5, 8, 9,
        10, 8, 11, 9, 12, 13, 14, 12, 15, 13, 16,
        17, 18, 16, 19, 17, 20, 21, 22, 20, 23, 21
    }
}

local text = {
    { x = 1.959, z = 0.036 }, { x = 1.799, z = 0.112 },
    { x = 1.906, z = -0.174 }, { x = 0.402, z = -0.044 },
    { x = 0.505, z = -0.119 }, { x = 0.791, z = 0.189 },
    { x = -0.146, z = -0.024 }, { x = -0.146, z = 0.092 },
    { x = -0.271, z = 0.444 }, { x = -0.850, z = 0.047 },
    { x = -0.787, z = -0.043 }, { x = -0.748, z = 0.103 },
    { x = 1.431, z = -0.024 }, { x = 1.556, z = 0.444 },
    { x = 1.431, z = 0.092 }, { x = -0.523, z = 0.329 },
    { x = -0.398, z = 0.444 }, { x = -0.746, z = 0.315 },
    { x = -1.363, z = 0.339 }, { x = -1.481, z = 0.418 },
    { x = -1.446, z = 0.262 }, { x = -1.288, z = -0.442 },
    { x = -1.251, z = -0.322 }, { x = -1.289, z = -0.326 },
    { x = -2.028, z = 0.009 }, { x = -1.889, z = 0.009 },
    { x = -1.959, z = 0.132 }, { x = 1.959, z = 0.036 },
    { x = 2.118, z = 0.109 }, { x = 2.124, z = 0.444 },
    { x = 2.124, z = 0.444 }, { x = 2.118, z = 0.109 },
    { x = 2.239, z = 0.444 }, { x = 2.239, z = 0.444 },
    { x = 2.118, z = 0.109 }, { x = 2.256, z = -0.426 },
    { x = 2.256, z = -0.426 }, { x = 2.118, z = 0.109 },
    { x = 2.129, z = -0.426 }, { x = 2.118, z = 0.109 },
    { x = 1.959, z = 0.036 }, { x = 2.011, z = -0.174 },
    { x = 2.011, z = -0.174 }, { x = 1.959, z = 0.036 },
    { x = 1.906, z = -0.174 }, { x = 1.677, z = 0.444 },
    { x = 1.799, z = 0.112 }, { x = 1.793, z = 0.444 },
    { x = 1.793, z = 0.444 }, { x = 1.799, z = 0.112 },
    { x = 1.959, z = 0.036 }, { x = 1.799, z = 0.112 },
    { x = 1.662, z = -0.426 }, { x = 1.787, z = -0.426 },
    { x = 1.799, z = 0.112 }, { x = 1.677, z = 0.444 },
    { x = 1.662, z = -0.426 }, { x = 0.476, z = -0.410 },
    { x = 0.520, z = -0.289 }, { x = 0.399, z = -0.330 },
    { x = 0.399, z = -0.330 }, { x = 0.505, z = -0.119 },
    { x = 0.402, z = -0.044 }, { x = 0.945, z = -0.284 },
    { x = 0.799, z = -0.291 }, { x = 0.842, z = -0.407 },
    { x = 0.842, z = -0.407 }, { x = 0.561, z = -0.315 },
    { x = 0.476, z = -0.410 }, { x = 0.799, z = -0.291 },
    { x = 0.945, z = -0.284 }, { x = 0.849, z = -0.193 },
    { x = 0.561, z = -0.315 }, { x = 0.842, z = -0.407 },
    { x = 0.799, z = -0.291 }, { x = 0.516, z = 0.313 },
    { x = 0.380, z = 0.320 }, { x = 0.469, z = 0.224 },
    { x = 0.380, z = 0.320 }, { x = 0.516, z = 0.313 },
    { x = 0.476, z = 0.427 }, { x = 0.476, z = 0.427 },
    { x = 0.769, z = 0.315 }, { x = 0.841, z = 0.419 },
    { x = 0.516, z = 0.313 }, { x = 0.769, z = 0.315 },
    { x = 0.476, z = 0.427 }, { x = 0.841, z = 0.419 },
    { x = 0.769, z = 0.315 }, { x = 0.874, z = 0.389 },
    { x = 0.874, z = 0.389 }, { x = 0.791, z = 0.189 },
    { x = 0.908, z = 0.145 }, { x = 0.791, z = 0.189 },
    { x = 0.874, z = 0.389 }, { x = 0.769, z = 0.315 },
    { x = 0.520, z = -0.289 }, { x = 0.476, z = -0.410 },
    { x = 0.561, z = -0.315 }, { x = 0.505, z = -0.119 },
    { x = 0.399, z = -0.330 }, { x = 0.520, z = -0.289 },
    { x = 0.791, z = 0.189 }, { x = 0.505, z = -0.119 },
    { x = 0.908, z = 0.145 }, { x = 0.145, z = 0.092 },
    { x = 0.270, z = 0.444 }, { x = 0.145, z = 0.444 },
    { x = 0.270, z = 0.444 }, { x = 0.145, z = -0.024 },
    { x = 0.270, z = -0.426 }, { x = 0.270, z = -0.426 },
    { x = 0.145, z = -0.024 }, { x = 0.145, z = -0.426 },
    { x = 0.145, z = 0.092 }, { x = 0.145, z = -0.024 },
    { x = 0.270, z = 0.444 }, { x = -0.146, z = -0.024 },
    { x = -0.271, z = -0.426 }, { x = -0.146, z = -0.426 },
    { x = 0.145, z = 0.092 }, { x = -0.146, z = -0.024 },
    { x = 0.145, z = -0.024 }, { x = -0.271, z = 0.444 },
    { x = -0.146, z = 0.092 }, { x = -0.146, z = 0.444 },
    { x = -0.146, z = 0.092 }, { x = -0.146, z = -0.024 },
    { x = 0.145, z = 0.092 }, { x = -0.146, z = -0.024 },
    { x = -0.271, z = 0.444 }, { x = -0.271, z = -0.426 },
    { x = -0.905, z = -0.332 }, { x = -0.782, z = -0.285 },
    { x = -0.926, z = -0.058 }, { x = -0.926, z = -0.058 },
    { x = -0.787, z = -0.043 }, { x = -0.850, z = 0.047 },
    { x = -0.850, z = 0.047 }, { x = -0.748, z = 0.103 },
    { x = -0.910, z = 0.226 }, { x = -0.910, z = 0.226 },
    { x = -0.748, z = 0.103 }, { x = -0.782, z = 0.263 },
    { x = -0.748, z = 0.103 }, { x = -0.787, z = -0.043 },
    { x = -0.584, z = 0.092 }, { x = -0.584, z = 0.092 },
    { x = -0.787, z = -0.043 }, { x = -0.545, z = -0.024 },
    { x = -0.584, z = -0.311 }, { x = -0.782, z = -0.285 },
    { x = -0.663, z = -0.426 }, { x = -0.663, z = -0.426 },
    { x = -0.782, z = -0.285 }, { x = -0.905, z = -0.332 },
    { x = -0.926, z = -0.058 }, { x = -0.782, z = -0.285 },
    { x = -0.787, z = -0.043 }, { x = 1.556, z = -0.426 },
    { x = 1.431, z = -0.311 }, { x = 1.024, z = -0.426 },
    { x = 1.024, z = -0.426 }, { x = 1.431, z = -0.311 },
    { x = 1.024, z = -0.311 }, { x = 1.024, z = 0.329 },
    { x = 1.431, z = 0.329 }, { x = 1.024, z = 0.444 },
    { x = 1.024, z = 0.444 }, { x = 1.431, z = 0.329 },
    { x = 1.556, z = 0.444 }, { x = 1.556, z = 0.444 },
    { x = 1.431, z = -0.024 }, { x = 1.556, z = -0.426 },
    { x = 1.556, z = -0.426 }, { x = 1.431, z = -0.024 },
    { x = 1.431, z = -0.311 }, { x = 1.431, z = -0.024 },
    { x = 1.170, z = 0.092 }, { x = 1.170, z = -0.024 },
    { x = 1.431, z = 0.092 }, { x = 1.556, z = 0.444 },
    { x = 1.431, z = 0.329 }, { x = 1.431, z = -0.024 },
    { x = 1.431, z = 0.092 }, { x = 1.170, z = 0.092 },
    { x = -0.663, z = -0.426 }, { x = -0.523, z = -0.311 },
    { x = -0.584, z = -0.311 }, { x = -0.523, z = -0.024 },
    { x = -0.523, z = 0.092 }, { x = -0.545, z = -0.024 },
    { x = -0.545, z = -0.024 }, { x = -0.523, z = 0.092 },
    { x = -0.584, z = 0.092 }, { x = -0.398, z = -0.426 },
    { x = -0.523, z = -0.311 }, { x = -0.663, z = -0.426 },
    { x = -0.398, z = -0.426 }, { x = -0.523, z = -0.024 },
    { x = -0.523, z = -0.311 }, { x = -0.782, z = 0.263 },
    { x = -0.860, z = 0.383 }, { x = -0.910, z = 0.226 },
    { x = -0.746, z = 0.315 }, { x = -0.860, z = 0.383 },
    { x = -0.782, z = 0.263 }, { x = -0.398, z = 0.444 },
    { x = -0.523, z = -0.024 }, { x = -0.398, z = -0.426 },
    { x = -0.523, z = -0.024 }, { x = -0.398, z = 0.444 },
    { x = -0.523, z = 0.092 }, { x = -0.523, z = 0.092 },
    { x = -0.398, z = 0.444 }, { x = -0.523, z = 0.329 },
    { x = -0.746, z = 0.315 }, { x = -0.398, z = 0.444 },
    { x = -0.860, z = 0.383 }, { x = -1.092, z = 0.383 },
    { x = -1.200, z = 0.314 }, { x = -1.050, z = -0.290 },
    { x = -1.050, z = -0.290 }, { x = -1.166, z = -0.244 },
    { x = -1.132, z = -0.401 }, { x = -1.132, z = -0.401 },
    { x = -1.251, z = -0.322 }, { x = -1.288, z = -0.442 },
    { x = -1.132, z = -0.401 }, { x = -1.166, z = -0.244 },
    { x = -1.251, z = -0.322 }, { x = -1.208, z = 0.450 },
    { x = -1.200, z = 0.314 }, { x = -1.092, z = 0.383 },
    { x = -1.050, z = -0.290 }, { x = -1.200, z = 0.314 },
    { x = -1.166, z = -0.244 }, { x = -1.562, z = 0.308 },
    { x = -1.446, z = 0.262 }, { x = -1.481, z = 0.418 },
    { x = -1.481, z = 0.418 }, { x = -1.363, z = 0.339 },
    { x = -1.208, z = 0.450 }, { x = -1.447, z = -0.417 },
    { x = -1.414, z = -0.294 }, { x = -1.522, z = -0.363 },
    { x = -1.522, z = -0.363 }, { x = -1.414, z = -0.294 },
    { x = -1.562, z = 0.308 }, { x = -1.414, z = -0.294 },
    { x = -1.447, z = -0.417 }, { x = -1.289, z = -0.326 },
    { x = -1.446, z = 0.262 }, { x = -1.562, z = 0.308 },
    { x = -1.414, z = -0.294 }, { x = -1.208, z = 0.450 },
    { x = -1.363, z = 0.339 }, { x = -1.200, z = 0.314 },
    { x = -1.288, z = -0.442 }, { x = -1.289, z = -0.326 },
    { x = -1.447, z = -0.417 }, { x = -1.889, z = 0.009 },
    { x = -1.959, z = -0.114 }, { x = -1.642, z = -0.426 },
    { x = -1.642, z = -0.426 }, { x = -1.959, z = -0.114 },
    { x = -1.781, z = -0.426 }, { x = -1.959, z = -0.114 },
    { x = -2.275, z = -0.426 }, { x = -2.136, z = -0.426 },
    { x = -1.781, z = 0.444 }, { x = -1.959, z = 0.132 },
    { x = -1.642, z = 0.444 }, { x = -1.642, z = 0.444 },
    { x = -1.959, z = 0.132 }, { x = -1.889, z = 0.009 },
    { x = -2.275, z = 0.444 }, { x = -1.959, z = 0.132 },
    { x = -2.136, z = 0.444 }, { x = -1.889, z = 0.009 },
    { x = -2.028, z = 0.009 }, { x = -1.959, z = -0.114 },
    { x = -1.959, z = -0.114 }, { x = -2.028, z = 0.009 },
    { x = -2.275, z = -0.426 }, { x = -2.028, z = 0.009 },
    { x = -1.959, z = 0.132 }, { x = -2.275, z = 0.444 },

    indices = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
        23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
        33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
        43, 44, 45, 46, 47, 48, 49, 50, 51, 52,
        53, 54, 55, 56, 57, 58, 59, 60, 61, 62,
        63, 64, 65, 66, 67, 68, 69, 70, 71, 72,
        73, 74, 75, 76, 77, 78, 79, 80, 81, 82,
        83, 84, 85, 86, 87, 88, 89, 90, 91, 92,
        93, 94, 95, 96, 97, 98, 99, 100, 101,
        102, 103, 104, 105, 106, 107, 108, 109,
        110, 111, 112, 113, 114, 115, 116, 117,
        118, 119, 120, 121, 122, 123, 124, 125,
        126, 127, 128, 129, 130, 131, 132, 133,
        134, 135, 136, 137, 138, 139, 140, 141,
        142, 143, 144, 145, 146, 147, 148, 149,
        150, 151, 152, 153, 154, 155, 156, 157,
        158, 159, 160, 161, 162, 163, 164, 165,
        166, 167, 168, 169, 170, 171, 172, 173,
        174, 175, 176, 177, 178, 179, 180, 181,
        182, 183, 184, 185, 186, 187, 188, 189,
        190, 191, 192, 193, 194, 195, 196, 197,
        198, 199, 200, 201, 202, 203, 204, 205,
        206, 207, 208, 209, 210, 211, 212, 213,
        214, 215, 216, 217, 218, 219, 220, 221,
        222, 223, 224, 225, 226, 227, 228, 229,
        230, 231, 232, 233, 234, 235, 236, 237,
        238, 239, 240, 241, 242, 243, 244, 245,
        246, 247, 248, 249, 250, 251, 252, 253,
        254, 255, 256, 257, 258, 259, 260, 261,
        262, 263, 264, 265, 266, 267, 268, 269,
        270, 271, 272, 273, 274, 275, 276, 277,
        278, 279, 280, 281, 282, 283, 284, 285,
        286, 287
    }
}

sv_identity("meshbox-bios")

local p = 1

local function wrap(fn, ...)
    local status, err = pcall(fn, ...)

    if status then return end

    function mb_frame(dt)
        mb_error(err, debug.traceback(), dt)
    end
end

local lerp = function(a, b, t)
    return a * (1 - t) + b * t
end

local next_mb_frame = false

local stage = 1
local stages = {
    [1] = function(dt)
        p = lerp(p, 0, dt * 2)
        mx_mode("projection")
        mx_perspective(100, 0, 1000)

        local e = (p * 1)
        mx_mode("view")
        mx_look_at(
            math.sin(e) * 5, math.cos(e) * 5, p * 10,
            0, 0, 0,
            0, 0, 1
        )

        local i = 1 - p
        mx_mode("model")
        mx_translate(0, 0, (p * 10) + 0.6)
        mx_scale(i * 1.1, i * 1.1, i * 1.1)

        -- I feel like meshbox should allow for you
        -- to re-render a mesh, so you dont have to
        -- upload twice :/
        vx_mesh(cube)
        vx_render(cube.indices)

        mx_translate(0, 0, -1.8)
        vx_mesh(text)
        vx_render(text.indices)

        mx_translate(0, 0, 1.8)

        tx_bind("<meshbox>")
        mx_scale(0.9, 0.9, 0.9)
        li_ambient(1, 1, 1, 1)

        vx_mesh(cube)
        vx_render(cube.indices)

        if (p < 0.001) and not __MB_FLAG_NO_GAME then
            p = 1
            stage = 2
        end
    end,

    [2] = function(dt)
        p = lerp(p, 0, dt * 3)
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
        mx_translate(0, 0, 0.6)
        mx_euler((1 - p) * 3, 1 - p, 0)
        mx_scale(p * 1.1, p * 1.1, p * 1.1)

        vx_mesh(cube)
        vx_render(cube.indices)

        mx_translate(0, 0, -1.8)
        vx_mesh(text)
        vx_render(text.indices)

        mx_translate(0, 0, 1.8)

        tx_bind("<meshbox>")
        mx_scale(0.9, 0.9, 0.9)
        vx_mesh(cube)
        vx_render(cube.indices)

        if (p < 0.01) then
            wrap(require, "meshbox")

            function mb_frame(dt)
                wrap(mb_loop, dt)
            end
        end
    end
}

function mb_error(err, traceback, dt)
    print(err, traceback)
end

function mb_frame(dt)
    if in_button("x") or in_button("y") then
        p = 0
        stage = 2
    end
    wrap(stages[stage], dt)
end