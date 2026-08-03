{ config, lib, pkgs, flakeInputs, hyprland, paths, ... }:

let
  cfg = config.modules.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
  hyprPkgs = hyprland.packages.${system};
  hyprPackage = hyprPkgs.hyprland;

  hostName = config.networking.hostName;
  hostHyprpaperConfig = "/home/mit/.config/hypr/hyprpaper.${hostName}.conf";
  hostWaybarCSSConfig = "/home/mit/.config/hypr/waybar.${hostName}.css";
  hostWaybarConfig = "/home/mit/.config/hypr/waybar.${hostName}.conf";
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users."mit" = { config, ... }:

      let
        externalOrText = path: fallback:
          if builtins.pathExists path then {
            source = config.lib.file.mkOutOfStoreSymlink path;
          } else {
            text = fallback;
          };
      in
      {
        xdg.configFile."hypr/hyprpaper.conf" =
          externalOrText hostHyprpaperConfig ''
            wallpaper {
                monitor =
                path = ${cfg.wallpaper}
                fit_mode = cover
            }
          '';

        xdg.configFile."waybar/config" =
          externalOrText hostWaybarConfig ''
            {
              "layer": "top",
              "position": "bottom",
              "height": 20
            }
          '';

        xdg.configFile."waybar/style.css" =
          externalOrText hostWaybarCSSConfig ''
            * {
                min-height: 0;
                margin: 0;
                padding: 0;
                border: none;
            }

            window#waybar {
                background-color: rgba(0, 0, 0, 0.9);
            }
          '';

        # übrige Home-Manager-Konfiguration …
      };
  };
}
