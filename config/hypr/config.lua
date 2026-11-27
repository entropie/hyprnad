local config_home = os.getenv("XDG_CONFIG_HOME")
if not config_home or config_home == "" then
    config_home = os.getenv("HOME") .. "/.config"
end

local keymap_path = config_home .. "/xkb/mykbd.xkb"
local keymap = io.open(keymap_path, "r")
if keymap then
    keymap:close()
end

-- Look & Feel --
hl.config({
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },

    input = {
        sensitivity = 0,
        accel_profile = "flat",
        kb_layout = "de",
        kb_options = "ctrl:nocaps",
        kb_file = keymap and keymap_path or nil,
        follow_mouse = 2
    },

    gestures = {
        workspace_swipe_touch = true,
        workspace_swipe_touch_invert = false,
        workspace_swipe_distance = 300,
    },

    general = {
        layout = "master",

        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        allow_tearing = true,
        col = {
            active_border = { colors = { "rgba(26c021ee)", "rgba(273527ee)" }, angle = 45 },
            inactive_border = "rgba(111111aa)",
        },
    },

    dwindle = {
        smart_split = false,
        preserve_split = true,
    },

    master = {
       mfact = 0.55,
       new_status = "slave"
    },

    decoration = {
        rounding = 0,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
        dim_special = 1,
    },

    animations = {
       enabled = true,
    },
    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo   = false,
        key_press_enables_dpms = false,
        mouse_move_enables_dpms = true
    }

})


hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
