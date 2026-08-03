{ config, hyprnadInputs, lib, ... }:

let
  cfg = config.modules.hyprland;
  hostName = config.networking.hostName;

  hyprConfigDir =
    if cfg.configDir == null then
      "${hyprnadInputs.self}/config/hypr"
    else
      cfg.configDir;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users.${cfg.user} = hmArgs: {
      xdg.configFile."waybar/config".source =
        if cfg.configDir == null then
          "${hyprConfigDir}/waybar.${hostName}.conf"
        else
          hmArgs.config.lib.file.mkOutOfStoreSymlink
            "${hyprConfigDir}/waybar.${hostName}.conf";

      xdg.configFile."waybar/style.css".source =
        if cfg.configDir == null then
          "${hyprConfigDir}/waybar.${hostName}.css"
        else
          hmArgs.config.lib.file.mkOutOfStoreSymlink
            "${hyprConfigDir}/waybar.${hostName}.css";

      xdg.configFile."hyprpaper/current.conf".source =
        if cfg.configDir == null then
          "${hyprConfigDir}/hyprpaper.${hostName}.conf"
        else
          hmArgs.config.lib.file.mkOutOfStoreSymlink
            "${hyprConfigDir}/hyprpaper.${hostName}.conf";
    };
  };
}
