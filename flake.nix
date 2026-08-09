{
  description = "hyprnad is hyprland configured my xmonad used to be";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.56.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland = {
      url = "github:hyprland-community/pyprland/3.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprgamma-src = {
      url = "github:surprizeattackxx-dotcom/hypr-gamma";
      flake = false;
    };

    Hyprspace = {
      url = "github:entropie/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs@{ self, ... }: {
    nixosModules = rec {
      default = import ./modules/hyprland {
        inherit inputs;
      };

      hyprland = default;
    };
  };
}
