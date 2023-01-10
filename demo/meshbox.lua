local vertices, indices = vx_load("cube.iqm")

local cubes = {}
for i=1, 30 do
    table.insert(cubes, {
        x=math.random(-10, 10), y=math.random(-10, 10)
    })
end

local x, y = 0, 0

local a = 0
function mb_loop(dt)
    a = a + dt * 12

    local mx, my = in_joystick("left")
    x = x + mx * dt * 16
    y = y + my * dt * 16

    mx_mode("projection")
    mx_perspective(100, 0.1, 1000)

    mx_mode("view")
    mx_look_at(
        x, y+5, 2,
        x, y, 0,
        0, 0, 1
    )

    li_ambient(0.2, 0.3, 0.4, 1)
    li_light(
        "point",
        x, y, 0,
        1, 1, 1
    )

    mx_mode("model")
    for _, v in ipairs(cubes) do
        mx_identity()
        mx_translate(v.x*5, v.y*5, 0)
        mx_scale(1, 1, 10)
        vx_mesh(vertices)
        vx_render(indices)
    end

    gx_background(0.1, 0.2, 0.3, 1)
end