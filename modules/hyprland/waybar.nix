{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ waybar ];
    home-manager.users."mit" = {
      xdg.configFile."waybar/config".text = ''
{
  "layer": "top",
  "position": "bottom",
  "height": 20,
  "spacing": 0,
  "output": ${cfg.display},
  "on-sigusr1": "toggle",

  "modules-left": ["hyprland/workspaces"],
  "modules-center":["hyprland/window"],
  "modules-right":["network", "tray", "battery", "clock#norm", "clock#secs"],

  "hyprland/workspaces": {
    "format": "{name}",
    "all-outputs": true,
    "active-only": false,
    "sort-by": "id",
  },


  "clock#norm": {
    "interval": 10,
    "format": "{:%H%M}",
    "max-length": 25
                  },


  "clock#secs": {
    "interval": 1,
    "format": "<span>{:%S}</span>",
    "max-length": 25
},


  "hyprland/window": {
    "max-length": 55,
    "format": "{}",
    "separate-outputs": false,
    "rewrite": {
      "": "🪹"
    },

  },

  "tray": {
    "spacing": 2,
    "icon-size": 20
  },


  "group/system": {
    "orientation": "horizontal",
    "modules":[
      "custom/notification",
      "bluetooth",
      "battery"
    ]
  },

  "bluetooth": {
    "format": "{icon}",
    "format-icons": {
      "enabled": "󰂱",
      "connected": "ᛒ",
      "disconnected": "󰂲"
    },
    "on-click": "ghostty --class=waybar.popup --confirm-close-surface=false -e bluetui"
  },

  "network": {
    "interface": "wlan0",
    "format-wifi": "{bandwidthTotalBytes}",
    "format-disconnected": "",
    "tooltip-format": "{essid}: {ipaddr}",
  },

  "battery": {
    "states": { "warning": 30, "critical": 15 },
    "format": "{icon}",
    "format-icons": ["🪫", "🪫", "🔋", "🔋", "🔋⚡"]
  }
}
      '';

      xdg.configFile."waybar/style.css".text = ''
        * {
            min-height: 0;
            margin: 0;
            padding: 0;
            border: none;
            border-radius: 0;
            font-family: "Terminus";
            background-color: rgba(0, 0, 0, 0.9);
        }

        window#waybar {
        }

        image {
            padding: 10px;
        }
        
        /*
          Main glassmorphism blocks + the system pill container
        */
        #waybar {
            color: rgba(23,173,6, .8);
            font-size: 20px;
            letter-spacing: -2px;
        }

        
        #clock,
        #tray,
        #system {
        }

        #clock {
            letter-spacing: 0px;
        }
        #clock.norm {
            color: rgba(100,140,50, 1);
            margin: 0;
            padding: 0;
        }
        #clock.secs {
            font-weight: bold;
            margin-right: 5px;
        }
        
        /* The System Pill container's outer padding */
        #system {
            margin-left: 0px;
            margin-right: 0px;
            padding: 0 4px;
        }

        #network {
            margin-right: 50px;
            color: #386b02;
        }
        #battery {
            padding: 0;
            background-color: #0b0619;
            opacity: .7;
            margin-right: 20px;            
        }

        #tray {
            background-color: rgba(43, 2, 27, .7);;
            padding: 0;
            opacity: .7;
            margin-right: 50px;
        }
        
        #bluetooth {
            font-size: 16px;
        }

        #workspaces button {
            opacity: .2;
        }

        #workspaces button.visible {
            opacity: .5;
        }

        #workspaces button.active {
            opacity: 1;
        }
'';
    };
  };
}
