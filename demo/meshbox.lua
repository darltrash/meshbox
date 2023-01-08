local vertices, indices = vx_load("meshbox.iqm")
print(table.concat(indices, ", "))

for k, v in ipairs(vertices) do
    print(("{x=%f, y=%f, z=%f, u=%f, v=%f},"):format(v.x, v.y, v.z, v.u, v.v))
end

local a = 0
function mb_loop(dt)
    a = a + dt * 12

    tx_bind("<meshbox>")
    mx_mode("projection")
    mx_perspective(100, 0, 1000)

    mx_mode("view")
    mx_look_at(
        math.sin(a)*3, math.cos(a)*3, 3,
        0, 0, 0,
        0, 0, 1
    )

    mx_mode("model")
    mx_identity()
    vx_mesh(vertices)
    vx_render(indices)

    gx_background(0, 0, 0, 1)
end