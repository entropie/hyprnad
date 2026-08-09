local uwsm_session = "uwsm-app -s s -t service -- "
local uwsm_background = "uwsm-app -s b -t service -- "

hl.on("hyprland.start", function()
    hl.exec_cmd(uwsm_session .. "waybar")
    hl.exec_cmd(uwsm_session .. "swaync")

    hl.exec_cmd(uwsm_session .. "nm-applet")

    hl.exec_cmd(uwsm_session .. "pypr")

    hl.exec_cmd(uwsm_background .. "copyq")
    hl.exec_cmd(uwsm_background .. "jellyfin-mpv-shim")

    hl.exec_cmd([[mountpoint -q "$HOME/Drive" || uwsm-app -- $HOME/bin/drivemount]])
end)
