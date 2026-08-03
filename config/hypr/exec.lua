local uwsm_session = "uwsm-app -s s -t service -- "
local uwsm_background = "uwsm-app -s b -t service -- "

hl.on("hyprland.start", function()
    hl.exec_cmd([[xrandr --output DP-2 --primary]])

    hl.exec_cmd(uwsm_session .. "waybar")
    hl.exec_cmd(uwsm_session .. "swaync")

    hl.exec_cmd(uwsm_session .. "nm-applet")
    -- hl.exec_cmd(uwsm_session .. "hypridle")
    -- hl.exec_cmd(uwsm_session .. "sway-audio-idle-inhibit")

    -- hl.exec_cmd(uwsm_session .. "elephant")
    -- hl.exec_cmd(uwsm_session .. "walker --gapplication-service")


    hl.exec_cmd(uwsm_session .. "pypr")

    -- hl.exec_cmd(uwsm_background .. "hyprpaper")
    -- hl.exec_cmd(uwsm_session .. "hypridle")


    hl.exec_cmd(uwsm_background .. "copyq")

    hl.exec_cmd(uwsm_background .. "jellyfin-mpv-shim")

    hl.exec_cmd([[mountpoint -q "$HOME/Drive" || uwsm-app -- $HOME/bin/drivemount]])

end)
