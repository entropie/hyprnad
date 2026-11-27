{ config, hyprnadInputs, lib, ... }:

let
  cfg = config.modules.hyprland;
  hostName = config.networking.hostName;
  bundledDir = "${hyprnadInputs.self}/config/hypr";
in
{
  options.modules.hyprland.desktopProfile = lib.mkOption {
    type = lib.types.str;
    default = if builtins.pathExists "${bundledDir}/waybar.${hostName}.conf"
      then hostName else "default";
    description = "Waybar and hyprpaper file profile. Set this for profiles available only in a writable configDir.";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${cfg.user} = { config, ... }:
      let
        profile = cfg.desktopProfile;
        source = name:
          if cfg.configDir == null then "${bundledDir}/${name}"
          else config.lib.file.mkOutOfStoreSymlink "${cfg.configDir}/${name}";
      in
      {
        xdg.configFile."waybar/config".source = source "waybar.${profile}.conf";
        xdg.configFile."waybar/style.css".source = source "waybar.${profile}.css";
        xdg.configFile."hyprpaper/current.conf" = lib.mkIf (profile != "default") {
          source = source "hyprpaper.${profile}.conf";
        };
      };
  };
}
