hl.device({
    name = "ydotoold-virtual-device",
    kb_file = "",
    kb_layout = "us",
    kb_variant = "basic",
})

hl.on("hyprland.start", function()
   hl.exec_cmd("hyprctl plugin load /run/current-system/sw/lib/libhyprgamma.so")
end)
