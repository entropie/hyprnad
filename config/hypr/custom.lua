hl.on("hyprland.start", function()
   hl.exec_cmd("hyprctl plugin load /run/current-system/sw/lib/libhyprgamma.so")
   hl.exec_cmd("hyprctl plugin load /run/current-system/sw/lib/libHyprspace.so")
end)
