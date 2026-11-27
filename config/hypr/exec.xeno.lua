dofile(os.getenv("HOME") .. "/.config/hypr/exec.personal.lua")

hl.on("hyprland.start", function()
         hl.exec_cmd([[xrandr --output DP-2 --primary]])
end)
