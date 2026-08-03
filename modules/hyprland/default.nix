{ inputs }:

{ config, lib, pkgs, ... }:

let
  flakeInputs = inputs;
  hyprland = inputs.hyprland;


  cfg = config.modules.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
  hyprPkgs = hyprland.packages.${system};
  hyprPackage = hyprPkgs.hyprland;

  hyprspace = flakeInputs.Hyprspace.packages.${system}.Hyprspace;

  hyprgamma = pkgs.callPackage
    ({ lib, cmake, pkg-config, nlohmann_json, hyprland, hyprlandPlugins }:
      hyprlandPlugins.mkHyprlandPlugin {
        pluginName = "hyprgamma";
        version = "1.0.0";
        src = flakeInputs."hyprgamma-src";
        nativeBuildInputs = [ cmake pkg-config ];
        buildInputs = [ nlohmann_json ];

        meta = {
          description = "Per-monitor gamma control for Hyprland";
          license = lib.licenses.bsd3;
          platforms = lib.platforms.linux;
        };
     })
    {
      hyprland = hyprPackage;
    };
in
{
  # imports = lib.custom.importAll ./.;

  _module.args = {
    inherit flakeInputs hyprland;
    paths = { };
  };

  
  imports = [
    hyprland.nixosModules.default
    ./hypridle.nix
    ./scripts.nix
    ./host-specific.nix
    ./pypr.nix
  ];

  options.modules.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop module";

    custom = lib.mkOption {
      type = lib.types.str;
      description = "custom hyprland settings";
    };

  };

  config = lib.mkIf cfg.enable {

    security.pam.services.greetd.enableGnomeKeyring = true;

    services.greetd = {
      enable = true;

      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session";
        user = "greeter";
      };
    };

    # Display Manager
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
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      #portalPackage = pkgs.xdg-desktop-portal-hyprland; # Use stable nixpkgs version to fix Qt version mismatch
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

  

    # Components
    services.gvfs.enable = true;
    programs.hyprlock.enable = true;

    environment.systemPackages = with pkgs; [
      swaynotificationcenter
      gnome-themes-extra
      libnotify

      playerctl
      brightnessctl

      loupe
      nautilus
      gnome-frog
      gnome-firmware
      gnome-calculator
      gnome-disk-utility

      wofi
      waybar
      eww
      wl-clipboard
      grim
      dunst

      hyprpaper
      hyprshot
      hyprpicker
      hypridle
      hyprlock
      hyprpolkitagent
      hyprland-qt-support
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Run electron apps without Xwayland
      NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    };

    environment.pathsToLink = [
      "/share/nautilus-python/extensions"
      "/share/hypr" # lua stub: /run/current-system/sw/share/hypr/stubs
    ];

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    home-manager.users."mit" = {

      xdg.configFile."hypr/custom.lua".text = ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("${hyprPackage}/bin/hyprctl plugin load ${hyprgamma}/lib/libhyprgamma.so")
          hl.exec_cmd("${hyprPackage}/bin/hyprctl plugin load ${hyprspace}/lib/libHyprspace.so")
          end)
          ${cfg.custom}
        '';


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
        '').overrideAttrs (_: { passthru.providedSessions = [ "uwsm-default" ]; })
      )
    ];

  };
}
