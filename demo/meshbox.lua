local vertices, indices = vx_load("barbie.iqm")

local a = 0
function mb_loop(dt)
    a = a + dt * 12

    mx_mode("projection")
    mx_perspective(100, 0, 1000)

    mx_mode("view")
    mx_look_at(
        0, 5, 0,
        0, 0, 0,
        0, 0, 1
    )

    mx_mode("model")
    mx_identity()
    gx_background(0, 0, 0, 1)
end