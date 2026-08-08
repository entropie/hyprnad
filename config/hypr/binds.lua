-- Apps
local term = "ghostty"
local uwsm = "uwsm-app -- "

local mainMod = "SUPER" 


local function toggle_keepassxc()
   local window = hl.get_active_window()

   if window and window.class == "org.keepassxc.KeePassXC" then
      hl.dispatch(hl.dsp.window.close())
   else
      hl.exec_cmd("uwsm-app keepassxc")
   end
end



hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(uwsm .. term))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd([[loginctl terminate-user "$USER"]]))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())

hl.bind(mainMod .. " + Y", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(uwsm .. "gmrun"))
hl.bind(mainMod .. " + G", function() hl.plugin.overview.toggle() end)

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))


hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(uwsm .. "missioncenter"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(uwsm .. "powermenu"))

-- Magic workspace
hl.bind(mainMod .. " + SPACE", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))



hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind("Print", hl.dsp.exec_cmd('grim - | satty -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png"'))

local pypr = "uwsm-app pypr-client"
hl.bind(mainMod .. " + X", toggle_keepassxc)
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(pypr .. " toggle music"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(pypr .. " toggle pavucontrol"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(pypr .. " toggle term"))
hl.bind(mainMod .. " + c", hl.dsp.exec_cmd(pypr .. " toggle copyq"))


-- PiP bind
hl.bind("SUPER + N", function()
    hl.dispatch(hl.dsp.window.float({ action = "on" }))
    hl.dispatch(hl.dsp.window.pin({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.resize({ exact = true, x = 640, y = 360 }))
    hl.dispatch(hl.dsp.window.move({ direction = "right" }))
    hl.dispatch(hl.dsp.window.move({ direction = "up" }))
end)

hl.bind(mainMod .. " + j", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + k", hl.dsp.layout("cycleprev"))

hl.bind(mainMod .. " + h", hl.dsp.layout("mfact -0.05"), { repeating = true })
hl.bind(mainMod .. " + l", hl.dsp.layout("mfact +0.05"), { repeating = true })

hl.bind(mainMod .. " + comma", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "-1" }))

-- Move window position within the layout
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "down" }))


-- https://www.unicode.org/emoji/charts/full-emoji-list.html#geometric
local workspaces = {
    { key = 1, id = 1,  name = "🔴" },
    { key = 2, id = 2,  name = "🟠" },
    { key = 3, id = 3,  name = "🟣" },
    { key = 4, id = 4,  name = "⭕" },
    { key = 5, id = 5,  name = "🟢" },
    { key = 6, id = 6,  name = "🟦" },
    { key = 7, id = 7,  name = "⚫" },
    { key = 8, id = 8,  name = "🔷" },
    { key = 9, id = 9,  name = "🟤" },
    { key = 0, id = 10, name = "💠" },
}

for _, ws in ipairs(workspaces) do
    hl.workspace_rule({
        workspace = tostring(ws.id),
        default_name = ws.name,
    })

    hl.bind(
        mainMod .. " + " .. ws.key,
        hl.dsp.focus({ workspace = ws.id, on_current_monitor = true })
    )

    hl.bind(
        mainMod .. " + SHIFT + " .. ws.key,
        hl.dsp.window.move({ workspace = ws.id, follow = false })
    )
end

hl.define_submap("media", function()
                    -- hl.bind("b", hl.dsp.dpms({ action = "disable" }), { release = true })

                    hl.bind("b", function()
                               hl.dispatch(hl.dsp.submap("reset"))
                               hl.dispatch(hl.dsp.dpms({ action = "disable" }))
                    end, { release = true})

                    hl.bind("s", function()
                               hl.dispatch(hl.dsp.submap("reset"))
                               hl.dispatch(hl.dsp.exec_cmd('hyprshot -m region --clipboard-only'))
                    end, { release = true})

                    hl.bind("SHIFT + S", function()
                               hl.dispatch(hl.dsp.submap("reset"))
                               hl.dispatch(hl.dsp.exec_cmd('hyprshot -m region'))
                    end, { release = true})

                    
                    
                    hl.bind("escape", hl.dsp.submap("reset"))
end)
hl.bind("SUPER + m", hl.dsp.submap("media"))

-- Mouse

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume Control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Media Control
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(uwsm .. "brightnessctl set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(uwsm .. "brightnessctl set 5%-"), { repeating = true, locked = true })
