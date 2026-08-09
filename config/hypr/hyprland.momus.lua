hl.on("hyprland.start", function()
    hl.exec_cmd("$HOME/bin/hl-motionsensor.sh")
end)

hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "auto",
    scale = 1,
    bitdepth = 10,
    cm = "srgb",
    vrr = 2,
    -- SDR to HDR
    -- sdr_min_luminance = 0.005,
    -- sdr_max_luminance = 200,
    -- sdrbrightness = 1.0,
    -- sdrsaturation = 1.0,
    -- HDR
    -- max_luminance = 430,
})
hl.config({
    render = {}
})

hl.device({
    name = "ilit2901:00-222a:5539",
    enabled = true,
    output = "eDP-1",
})

hl.device({
    name = "ilit2901:00-222a:5539-stylus",
    enabled = true,
    output = "eDP-1",
})

hl.bind("switch:on:gpio-keys", hl.dsp.exec_cmd("notify-send 'Tablet mode ON'"), { locked = true })
hl.bind("switch:off:gpio-keys", hl.dsp.exec_cmd("notify-send 'Tablet mode OFF'"), { locked = true })
