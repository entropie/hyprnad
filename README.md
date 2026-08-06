Hypernad is a nixos module that manages a bleeding edge @hyprland installation via source/flake with some plugins and ready to use configuration that is very xmonad orientied

## installation

````nix

    hyprnad = {
      url = "github:entropie/hyprnad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ...
    
    modules = [
      (./machines + "/${name}/configuration.nix")
      (./machines + "/${name}/hardware-configuration.nix")
      hyprnad.nixosModules.default
    ]


    # ...

    # in configuration.nix
    modules = {
      hyprland = {
        enable = true;
        user = "mit";
        configDir = "/home/mit/Source/hyprnad/config/hypr"; # when not provided config is used readonly from source
      };
    };

    
````

