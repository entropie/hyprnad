local uwsm_session = "uwsm-app -s s -t service -- "

hl.on("hyprland.start", function()
    hl.exec_cmd(uwsm_session .. "waybar")
    hl.exec_cmd(uwsm_session .. "swaync")
    hl.exec_cmd(uwsm_session .. "pypr")
end)
