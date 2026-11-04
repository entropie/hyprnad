-- Toggle the most recently hidden regular workspace on the current monitor.
local history = {}
local visible = {}
local pending = false

local function visible_workspaces()
    local result = {}

    for _, workspace in ipairs(hl.get_workspaces()) do
        if not workspace.special and workspace.active then
            local selector = workspace.id or ("name:" .. workspace.name)
            result[selector] = true
        end
    end

    return result
end

local function remember(selector)
    for i = #history, 1, -1 do
        if history[i] == selector then
            table.remove(history, i)
        end
    end

    table.insert(history, 1, selector)

    -- Keep empty numbered workspaces too: Hyprland may destroy them on exit.
    if #history > 64 then
        table.remove(history)
    end
end

local function update()
    local current = visible_workspaces()

    for selector in pairs(visible) do
        if not current[selector] then
            remember(selector)
        end
    end

    visible = current
end

local function update_later()
    if pending then
        return
    end

    pending = true
    hl.timer(function()
        pending = false
        update()
    end, { timeout = 1, type = "oneshot" })
end

-- Seed visibility without inventing a history when loading/reloading the config.
visible = visible_workspaces()
hl.on("hyprland.start", update_later)
hl.on("workspace.active", update)
hl.on("workspace.move_to_monitor", update_later)
hl.on("monitor.added", update_later)
hl.on("monitor.removed", update_later)

local function toggle()
    update()

    for _, selector in ipairs(history) do
        if not visible[selector] then
            hl.dispatch(hl.dsp.focus({ workspace = selector, on_current_monitor = true }))
            update()
            return
        end
    end
end

return { toggle = toggle }
