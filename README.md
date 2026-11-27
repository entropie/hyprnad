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
In the host's `nixpkgs.lib.nixosSystem` module list, use your existing NixOS
username in place of `alice`.

```nix
modules = [
  ./configuration.nix
  home-manager.nixosModules.home-manager
  hyprnad.nixosModules.default
  {
    modules.hyprland = {
      enable = true;
      user = "alice";
      # Optional writable checkout:
      # configDir = "/home/alice/Source/hyprnad/config/hypr";
    };
  }
];
```

For a new Home Manager user, set `home-manager.users.alice.home.stateVersion`
to the Home Manager release used for the initial setup. Keep an existing
state version as configured. Omitting `configDir` uses the read-only
configuration shipped with the flake.
