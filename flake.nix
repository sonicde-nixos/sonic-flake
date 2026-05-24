{
  description = "Top level flake for all things sonic-DE related!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    ################################################################################################
    #
    # fyi: working on this file in a IDE that supports collapsing brackets would probably be nice
    #
    # TO ADD AN INPUT:
    #   create a folder in the sonic-flakes folder in the repo, and create a flake.nix inside of it
    #   fill out the flake.nix with whatever should be in it
    #   add to this block:
    #     input-name.url = "path:./input-name";
    #   then add in the block right below it:
    #     input-name.inputs.nixpkgs.follows = "nixpkgs";
    #   add the input name to the outputs block
    #   add to the packages block:
    #     input-name = input-name.packages.${system}.default;
    #   please also consider adding your new input to the devshell section, if you feel like it! (idk how devshells work :p)
    #
    # TO TEST THINGS OUT:
    #   run $> nix flake update
    #          nix build .#input
    #
    ################################################################################################

    #
    # .url = "path:./
    # ";
    #

    #silver-sddm.url = "path:./silver-sddm";
    silver-theme.url = "path:./silver-theme";
    sonic-activities.url = "path:./sonic-activities";
    #sonic-audio-applet-pulse.url = "path:./sonic-audio-applet-pulse";
    sonic-decoration.url = "path:./sonic-decoration";
    sonic-desktop-interface.url = "path:./sonic-desktop-interface";
    sonic-frameworks-auth.url = "path:./sonic-frameworks-auth";
    sonic-frameworks-core-addons.url = "path:./sonic-frameworks-core-addons";
    #sonic-frameworks-doctools.url = "path:./sonic-frameworks-doctools";
    sonic-frameworks-io.url = "path:./sonic-frameworks-io";
    #sonic-frameworks-io-extras.url = "path:./sonic-frameworks-io-extras";
    #sonic-frameworks-keybind.url = "path:./sonic-frameworks-keybind";
    #sonic-frameworks-quick-ui.url = "path:./sonic-frameworks-quick-ui";
    #sonic-frameworks-runner.url = "path:./sonic-frameworks-runner";
    #sonic-frameworks-windowsystem.url = "path:./sonic-frameworks-windowsystem";
    sonic-interface-libraries.url = "path:./sonic-interface-libraries";
    sonic-keybind-daemon.url = "path:./sonic-keybind-daemon";
    #sonic-login-manager.url = "path:./sonic-login-manager";
    #sonic-mobile-interface.url = "path:./sonic-mobile-interface";
    #sonic-network-manager.url = "path:./sonic-network-manager";
    sonic-night-light.url = "path:./sonic-night-light";
    #sonic-screen.url = "path:./sonic-screen";
    #sonic-screen-library.url = "path:./sonic-screen-library";
    sonic-screenlocker.url = "path:./sonic-screenlocker";
    #sonic-sysguard.url = "path:./sonic-sysguard";
    sonic-sysguard-library.url = "path:./sonic-sysguard-library";
    sonic-system-info.url = "path:./sonic-system-info";
    sonic-win.url = "path:./sonic-win";
    sonic-workspace.url = "path:./sonic-workspace";
    sonic-workspace-addons.url = "path:./sonic-workspace-addons";
    #sonic-workspace-wallpapers.url = "path:./sonic-workspace-wallpapers";

  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,

    #silver-sddm,
    silver-theme,
    sonic-activities,
    #sonic-audio-applet-pulse,
    sonic-decoration,
    sonic-desktop-interface,
    sonic-frameworks-auth,
    sonic-frameworks-core-addons,
    #sonic-frameworks-doctools,
    sonic-frameworks-io,
    #sonic-frameworks-io-extras,
    #sonic-frameworks-keybind,
    #sonic-frameworks-quick-ui,
    #sonic-frameworks-runner,
    #sonic-frameworks-windowsystem,
    sonic-interface-libraries,
    sonic-keybind-daemon,
    #sonic-login-manager,
    #sonic-mobile-interface,
    #sonic-network-manager,
    sonic-night-light,
    #sonic-screen,
    #sonic-screen-library,
    sonic-screenlocker,
    #sonic-sysguard,
    sonic-sysguard-library,
    sonic-system-info,
    sonic-win,
    sonic-workspace,
    sonic-workspace-addons,
    #sonic-workspace-wallpapers,

    ...

  }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

      # all sonic inputs
        subFlakes = builtins.filterAttrs
          (name: _: !builtins.elem name ["nixpkgs" "flake-utils" "self"])
          inputs;

      # Apply follows to nixpkgs + flake-utils for every input. grok came up with this, hopefully it works :\
      inputsWithFollows = builtins.mapAttrs
          (name: input:
            if builtins.isAttrs input && input ? inputs
            then input // {
              inputs = (input.inputs or {}) // {
                nixpkgs.follows = "nixpkgs";
                flake-utils.follows = "flake-utils";
              };
            }
            else input
          )
          subFlakes;

      in
      {

        packages = {

          #
          # = 
          # .packages.${system}.default;
          #

          #silver-sddm = silver-sddm.packages.${system}.default;
          silver-theme = silver-theme.packages.${system}.default;
          sonic-activities = sonic-activities.packages.${system}.default;
          #sonic-audio-applet-pulse = sonic-audio-applet-pulse.packages.${system}.default;
          sonic-decoration = sonic-decoration.packages.${system}.default;
          sonic-desktop-interface = sonic-desktop-interface.packages.${system}.default;
          sonic-frameworks-auth = sonic-frameworks-auth.packages.${system}.default;
          sonic-frameworks-core-addons = sonic-frameworks-core-addons.packages.${system}.default;
          #sonic-frameworks-doctools = sonic-frameworks-doctools.packages.${system}.default;
          sonic-frameworks-io = sonic-frameworks-io.packages.${system}.default;
          #sonic-frameworks-io-extras = sonic-frameworks-io-extras.packages.${system}.default;
          #sonic-frameworks-keybind = sonic-frameworks-keybind.packages.${system}.default;
          #sonic-frameworks-quick-ui = sonic-frameworks-quick-ui.packages.${system}.default;
          #sonic-frameworks-runner = sonic-frameworks-runner.packages.${system}.default;
          #sonic-frameworks-windowsystem = sonic-frameworks-windowsystem.packages.${system}.default;
          sonic-interface-libraries = sonic-interface-libraries.packages.${system}.default;
          sonic-keybind-daemon = sonic-keybind-daemon.packages.${system}.default;
          #sonic-login-manager = sonic-login-manager.packages.${system}.default;
          #sonic-mobile-interface = sonic-mobile-interface.packages.${system}.default;
          #sonic-network-manager = sonic-network-manager.packages.${system}.default;
          sonic-night-light = sonic-night-light.packages.${system}.default;
          #sonic-screen = sonic-screen.packages.${system}.default;
          #sonic-screen-library = sonic-screen-library.packages.${system}.default;
          sonic-screenlocker = sonic-screenlocker.packages.${system}.default;
          #sonic-sysguard = sonic-sysguard.packages.${system}.default;
          sonic-sysguard-library = sonic-sysguard-library.packages.${system}.default;
          sonic-system-info = sonic-system-info.packages.${system}.default;
          sonic-win = sonic-win.packages.${system}.default;
          sonic-workspace = sonic-workspace.packages.${system}.default;
          sonic-workspace-addons = sonic-workspace-addons.packages.${system}.default;
          #sonic-workspace-wallpapers = sonic-workspace-wallpapers.packages.${system}.default;

        };







        #packages = builtins.mapAttrs
        #  (name: flake: flake.packages.${system}.default)
        #  sonicInputs;

        # Optional: a combined dev shell with everything. this might be nice if you want to debug stuff, but I won't ask you to update it too. commented out.
        /*devShells.default = pkgs.mkShell {
          inputsFrom = with self.packages.${system}; [
            sonic-win
            sonic-workspace
            sonic-desktop-interface
            sonic-screen-locker
            # ...
          ];
          packages = with pkgs; [ just gdb nix-output-monitor ];
          shellHook = ''
            echo "Sonic-DE monorepo dev environment ready"
          '';
        };*/
      }
    );
}



    /*

    silver-sddm
    silver-theme
    sonic-activities
    sonic-audio-applet-pulse
    sonic-decoration
    sonic-desktop-interface
    sonic-frameworks-auth
    sonic-frameworks-core-addons
    sonic-frameworks-doctools
    sonic-frameworks-io
    sonic-frameworks-io-extras
    sonic-frameworks-keybind
    sonic-frameworks-quick-ui
    sonic-frameworks-runner
    sonic-frameworks-windowsystem
    sonic-interface-libraries
    sonic-keybind-daemon
    sonic-login-manager
    sonic-mobile-interface
    sonic-network-manager
    sonic-night-light
    sonic-screen
    sonic-screen-library
    sonic-screenlocker
    sonic-sysguard
    sonic-sysguard-library
    sonic-system-info
    sonic-win
    sonic-workspace
    sonic-workspace-addons
    sonic-workspace-wallpapers

    */
