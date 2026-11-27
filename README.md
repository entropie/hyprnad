# hyprnad

An opinionated NixOS module for Hyprland, built from a pinned upstream release, with UWSM and an xmonad-inspired Lua configuration.

## Installation

hyprnad configures the desktop through the Home Manager **NixOS module**.
If your host already imports that module, keep the existing import. Otherwise,
add Home Manager alongside hyprnad in your system flake. This example uses
NixOS unstable and Home Manager master.

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  hyprnad = {
    url = "github:entropie/hyprnad";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Include `home-manager` and `hyprnad` in your flake's `outputs` arguments.
Add both modules to the host's `nixpkgs.lib.nixosSystem` module list.

```nix
modules = [
  ./configuration.nix
  home-manager.nixosModules.home-manager
  hyprnad.nixosModules.default
];
```

## Configuration

Add this block inside your host's `configuration.nix`. Replace `alice` with
the existing NixOS user who will run Hyprland.

```nix
modules.hyprland = {
  enable = true;
  user = "alice";

  # Optional: live-edit the desktop config without a NixOS rebuild.
  # configDir = "/home/alice/Source/hyprnad/config/hypr";

  # Optional: select a Waybar and hyprpaper profile explicitly.
  # desktopProfile = "laptop";
};
```

Set `configDir` if you want to tune the desktop while using it. After one
rebuild to activate the option, Home Manager links `~/.config/hypr` to your
checkout. You can then edit a binding in `binds.lua` and run
`hyprctl reload` to try it immediately, without rebuilding NixOS. For Waybar
changes, reload Waybar. Changes to the Nix module options still need a rebuild.

For a new Home Manager user, set `home-manager.users.alice.home.stateVersion`
to the Home Manager release used for the initial setup. Keep an existing
state version as configured.

| Option under `modules.hyprland` | Default | Effect |
| --- | --- | --- |
| `enable` | `false` | Enables the Hyprland desktop. |
| `user` | Required | Selects the user whose desktop files Home Manager manages. |
| `configDir` | `null` | Uses the configuration bundled with the flake. Set an absolute path to a writable copy of the full `config/hypr` directory to edit it in place. |
| `desktopProfile` | Hostname if a matching Waybar config ships with the flake, otherwise `"default"` | Selects `waybar.<profile>.conf` and `waybar.<profile>.css`. Named profiles also use `hyprpaper.<profile>.conf`. The generic profile disables hyprpaper. |
| `plugins.hyprgamma.enable` | `true` | Includes the gamma plugin in the system packages. If you disable it, also remove the load command from your copy of `custom.lua`. |

For a profile that exists only in your checkout, set both `configDir` and
`desktopProfile`. Host-specific Lua files use the actual hostname independently
of the desktop profile. For example, a host named `laptop` loads
`hyprland.laptop.lua` and `exec.laptop.lua` when those files exist.
