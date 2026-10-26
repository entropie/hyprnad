{ inputs }:

{ config, lib, pkgs, ... }:

let
  hyprnadInputs = inputs;
  hyprland = inputs.hyprland;

  cfg = config.modules.hyprland;
  system = pkgs.stdenv.hostPlatform.system;

  hyprPkgs = hyprland.packages.${system};
  hyprPackage = hyprPkgs.hyprland;
  hyprNixpkgs = hyprland.inputs.nixpkgs.legacyPackages.${system};

  hyprspace = hyprnadInputs.Hyprspace.packages.${system}.Hyprspace;

  hyprgamma = pkgs.callPackage
    ({ lib, cmake, nlohmann_json, hyprlandPlugins, ... }:
      hyprlandPlugins.mkHyprlandPlugin {
        pluginName = "hyprgamma";
        version = "1.0.2";

        hyprland = hyprPackage;
        src = hyprnadInputs."hyprgamma-src";

        nativeBuildInputs = [ cmake ];
        buildInputs = [ nlohmann_json ];

        meta = {
          description = "Per-monitor gamma control for Hyprland";
          license = lib.licenses.bsd3;
          platforms = lib.platforms.linux;
        };
      }
    ) { };
in
{
  imports = [
    hyprland.nixosModules.default
    ./pypr.nix
    ./host-specific.nix
  ];

  options.modules.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop module";

    plugins.hyprgamma.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    plugins.hyprspace.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    user = lib.mkOption {
      type = lib.types.str;
      example = "mit";
      description = "User receiving the Hyprland Home Manager configuration";
    };

    configDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional writable local hyprnad config checkout";
    };
  };

  config = lib.mkMerge [
    {
      _module.args = {
        inherit hyprland hyprnadInputs;
        paths = { };
      };
    }

    (lib.mkIf cfg.enable {
      # Point the capability wrapper at the actual ELF binary.
      security.wrappers.Hyprland.source =
        lib.mkForce "${config.programs.hyprland.package}/bin/.Hyprland-wrapped";

      hardware.graphics = {
        package = lib.mkOverride 900 hyprNixpkgs.mesa;
        package32 = lib.mkOverride 900 hyprNixpkgs.pkgsi686Linux.mesa;
      };


      security.pam.services.greetd.enableGnomeKeyring = true;

      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
        trusted-users = [ "root" "@wheel" ];
      };

      services.greetd = {
        enable = true;
        useTextGreeter = true;

        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
          user = "greeter";
        };
      };

      services.displayManager = {
        gdm.enable = false;
        defaultSession = "hyprland-uwsm";
      };

      systemd.services.display-manager.path = [
        pkgs.uwsm
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
        package = hyprPackage;
        portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
      };

      services.gvfs.enable = true;
      programs.hyprlock.enable = true;

      environment.systemPackages =
        (with pkgs; [
          swaynotificationcenter
          gnome-themes-extra
          libnotify

          playerctl
          brightnessctl

          loupe
          nautilus
          gnome-firmware
          gnome-calculator
          gnome-disk-utility

          wofi
          waybar
          eww
          wl-clipboard
          grim
          dunst
          xrandr

          hyprpaper
          hyprshot
          hyprpicker
          hypridle
          hyprlock
          hyprpolkitagent
          hyprland-qt-support
          hyprland-protocols
          hyprland-qtutils
        ])
        ++ lib.optional cfg.plugins.hyprgamma.enable hyprgamma
        ++ lib.optional cfg.plugins.hyprspace.enable hyprspace;

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        NAUTILUS_4_EXTENSION_DIR =
          "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
      };

      environment.pathsToLink = [
        "/share/nautilus-python/extensions"
        "/share/hypr"
      ];

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      home-manager.users.${cfg.user} = { config, ... }: {
        xdg.configFile."hypr".source =
          if cfg.configDir == null then
            "${inputs.self}/config/hypr"
          else
            config.lib.file.mkOutOfStoreSymlink cfg.configDir;

        services.hypridle.enable = true;
        services.hyprpaper.enable = true;

        gtk = {
          enable = true;

          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };

          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };

          gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };

        dconf.enable = true;
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
            font-name = "Adwaita Sans";
          };

          "org/gnome/desktop/wm/preferences" = {
            button-layout = ":";
          };
        };
      };

      services.displayManager.sessionPackages = [
        (
          (pkgs.writeTextDir "share/wayland-sessions/uwsm-default.desktop" ''
            [Desktop Entry]
            Version=1.0
            Name=UWSM (default)
            Exec=${pkgs.uwsm}/bin/uwsm start default
            Type=Application
          '').overrideAttrs (_: {
            passthru.providedSessions = [ "uwsm-default" ];
          })
        )
      ];
    })
  ];
}
