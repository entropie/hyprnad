{ config, flakeInputs, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flakeInputs.pyprland.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  
  home-manager.users."mit" = {
    xdg.configFile."pypr/config.toml".source =
      (pkgs.formats.toml { }).generate "pypr-config.toml" {
        pyprland = {
          plugins = [
            "scratchpads"
          ];
        };

        scratchpads = {
          music = {
            command = "ghostty --class=de.local.scratchpad.music --title=music -e zsh -lc 'exec ncmpcpp'";
            class = "de.local.scratchpad.music";
            match_by = "class";
            process_tracking = false;
            multi = false;
            lazy = true;
            position = "25% 25%";
            size = "50% 50%";
            pinned = false;
          };

          pavucontrol = {
            command = "pavucontrol";
            class = "org.pulseaudio.pavucontrol";

            lazy = true;
            multi = false;

            animation = "";
            position = "25% 25%";
            size = "50% 50%";

            pinned = false;
            smart_focus = false;
          };

          term = {
            command = "ghostty --class=de.local.scratchpad.term --title=scratchpad -e zsh -lc 'tmux attach -t scratchpad || exec tmux new-session -s scratchpad'";
            class = "de.local.scratchpad.term";
            match_by = "class";
            process_tracking = false;
            multi = false;
            lazy = true;
            position = "0% 0%";
            size = "100% 100%";
            pinned = false;
          };

          copyq = {
            command = "copyq toggle";
            class = "com.github.hluk.copyq";
            match_by = "class";
            process_tracking = false;
            multi = false;
            lazy = true;
            position = "10% 0%";
            size = "80% 100%";
            pinned = false;
          };

          # keepassxc = {
          #   command = "keepassxc";
          #   class = "org.keepassxc.KeePassXC";
          #   match_by = "class";
          #   process_tracking = false;
          #   multi = false;
          #   lazy = true;
          #   animation = "";
          #   position = "25% 25%";
          #   size = "50% 50%";
          #   pinned = false;
          #   smart_focus = false;
          # };

        };
      };
  };
}
