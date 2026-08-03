hl.window_rule({
      name = "emacs",
      match = { class = "^(Emacs)$" },
      workspace = "2",
})



hl.workspace_rule({
      workspace = "4",
      layout = "monocle",
      gaps_in = 0,
      gaps_out = 0,
      no_border = true,
      no_rounding = true
})



local function scratchpad_rule(name, class, opacity)
    local rule = {
        name = "scratchpad-" .. name,

        match = {
            initial_class =
                "^" .. class:gsub("%.", "[.]") .. "$",
        },

        float = true,
    }

    if opacity then
        rule.opacity =
            opacity .. " override "
            .. opacity .. " override"
    end

    hl.window_rule(rule)
end

scratchpad_rule(
    "music",
    "de.local.scratchpad.music",
    "0.70"
)

scratchpad_rule(
   "keepassxc",
   "org.keepassxc.KeePassXC",
   "0.70"
)

scratchpad_rule(
   "pavucontrol",
   "org.pulseaudio.pavucontrol",
   "0.70"
)



scratchpad_rule(
    "term",
    "de.local.scratchpad.term"
)


scratchpad_rule(
    "copyq",
    "com.github.hluk.copyq"
)


-- hl.window_rule({
--   name = "apply-something",
--   match = {
--     class = "my-window"
--   },
--   border_size = 10
-- })
-- hl.window_rule({
--   name = "emacs",
--   match = {
--     class = “^(emacs)$”
--   },
--   border_size = 10
-- })


hl.window_rule({
   name = "keepassxc",
   match = { class = "^KeePassXC$" },
   workspace = "special:keepassxc silent",
   float = true,
   size = { "(monitor_w / 3)", "(monitor_h / 3)" },
   move = { "10", "(monitor_h - window_h - 10)" },
})
