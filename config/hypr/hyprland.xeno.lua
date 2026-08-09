hl.on("hyprland.start", function()
         hl.exec_cmd([[xrandr --output DP-2 --primary]])
end)

hl.config({
    render = {}
})

-- Lenovo: top
hl.monitor({
    output = "DP-1",
    mode = "2560x1600@59.97",
    position = "1080x0",
    scale = 1,
    cm = "srgb",
})

-- HP: left, pivot
hl.monitor({
    output = "HDMI-A-2",
    mode = "1920x1080@60",
    position = "0x1120",
    scale = 1,
    transform = 1,
    cm = "srgb",
})

-- AOC: main, 144hz
hl.monitor({
    output = "DP-2",
    mode = "2560x1440@143.91",
    position = "1080x1600",
    scale = 1,
    cm = "srgb",
    vrr = 3,
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})


hl.config({
    cursor = {
           default_monitor = "DP-2"
    }

})
