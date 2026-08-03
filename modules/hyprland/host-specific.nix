{ config, lib, ... }:

let
  cfg = config.modules.hyprland;
  hostName = config.networking.hostName;


  hyprpaperConfig =
    if cfg.configDir == null then
      "${inputs.self}/config/hypr/hyprpaper.${hostName}.conf"
    else
      "${cfg.configDir}/hyprpaper.${hostName}.conf";

in
{
  config = lib.mkIf cfg.enable {y
    home-manager.users.${cfg.user} = { config, ... }: {
      xdg.configFile."waybar/config".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.xdg.configHome}/hypr/waybar.${hostName}.conf";

      xdg.configFile."waybar/style.css".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.xdg.configHome}/hypr/waybar.${hostName}.css";

      xdg.configFile."hyprpaper/current.conf".source =
        config.lib.file.mkOutOfStoreSymlink hyprpaperConfig;
    };
  };
}
