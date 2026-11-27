dofile(os.getenv("HOME") .. "/.config/hypr/exec.personal.lua")

hl.on("hyprland.start", function()
    hl.exec_cmd("$HOME/bin/hl-motionsensor.sh")
end)
