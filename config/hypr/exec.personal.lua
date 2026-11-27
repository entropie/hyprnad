local scripts_dir = os.getenv("HOME") .. "/Source/binscripts/bin"
local path = os.getenv("PATH") or ""

if not (":" .. path .. ":"):find(":" .. scripts_dir .. ":", 1, true) then
    hl.env("PATH", path .. ":" .. scripts_dir)
end

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm-app -s s -t service -- nm-applet")
    hl.exec_cmd("uwsm-app -s b -t service -- copyq")
    hl.exec_cmd("uwsm-app -s b -t service -- jellyfin-mpv-shim")
    hl.exec_cmd([[mountpoint -q "$HOME/Drive" || uwsm-app -- "$HOME/bin/drivemount"]])
end)
