{ config, lib, ... }:

let
  cfg = config.modules.hyprland;
  hostName = config.networking.hostName;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users.${cfg.user} = { config, ... }: {
      xdg.configFile."waybar/config".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.xdg.configHome}/hypr/waybar.${hostName}.conf";

      xdg.configFile."waybar/style.css".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.xdg.configHome}/hypr/waybar.${hostName}.css";
    };
  };
}
