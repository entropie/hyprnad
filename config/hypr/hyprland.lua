-- hl.monitor({
--     output = "",
--     mode = "preferred",
--     position = "auto",
--     scale = "auto",
-- })

require("custom")

local hostname_file = io.open("/etc/hostname", "r")
local hostname
if hostname_file then
    hostname = hostname_file:read("*l")
    hostname_file:close()
end

local function load_host_file(prefix)
    if not hostname then return end
    local path = os.getenv("HOME") .. "/.config/hypr/" .. prefix .. "." .. hostname .. ".lua"
    local file = io.open(path, "r")
    if file then
        file:close()
        dofile(path)
    end
end

load_host_file("hyprland")

require("config")
require("binds")
require("exec")
load_host_file("exec")
require("rules")

