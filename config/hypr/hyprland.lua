-- hl.monitor({
--     output = "",
--     mode = "preferred",
--     position = "auto",
--     scale = "auto",
-- })

require("custom")

require("custom")

local hostname = os.getenv("HOSTNAME")
local host_config = os.getenv("HOME") .. "/.config/hypr/custom." .. hostname .. ".lua"

local file = io.open(host_config, "r")

if file then
   file:close()
   dofile(host_config)
end



require("config")
require("binds")
require("exec")
require("rules")

