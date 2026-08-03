-- hl.monitor({
--     output = "",
--     mode = "preferred",
--     position = "auto",
--     scale = "auto",
-- })

require("custom")

local hostname_file = io.open("/etc/hostname", "r")

if hostname_file then
   local hostname = hostname_file:read("*l")
   hostname_file:close()

   local home = os.getenv("HOME")
   local host_config = home .. "/.config/hypr/hyprland." .. hostname .. ".lua"
   local file = io.open(host_config, "r")

   if file then
      file:close()
      dofile(host_config)
   end
end


require("config")
require("binds")
require("exec")
require("rules")

