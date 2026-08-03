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
        kb_file = "/home/mit/.config/xkb/mykbd.xkb",
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
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
    },

    dwindle = {
        smart_split = false,
        preserve_split = true, -- You probably want this
    },

    master = {
       mfact = 0.60,
       new_status = "slave"
    },

    decoration = {
        rounding = 5,
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
        force_default_wallpaper = 1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
        key_press_enables_dpms = false,
        mouse_move_enables_dpms = true
    }

})


hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
