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
    #   please also consider adding your new input to the devshell section, if you feel like it!
    #
    # TO TEST THINGS OUT:
    #   run $> nix build .#input
    #
    ################################################################################################

    sonic-desktop-interface.url = "path:./sonic-desktop-interface";
    #sonic-frameworks-auth.url = "path:./sonic-frameworks-auth";
    #sonic-frameworks-io.url = "path:./sonic-frameworks-io";
    #sonic-frameworks-windowsystem.url = "path:./sonic-frameworks-windowsystem";
    #sonic-interface-libraries.url = "path:./sonic-interface-libraries";
    #sonic-keybind-daemon.url = "path:./sonic-keybind-daemon";
    #sonic-screen.url = "path:./sonic-screen";
    #sonic-screen-library.url = "path:./sonic-screen-library";
    #sonic-screenlocker.url = "path:./sonic-screenlocker";
    #sonic-sysguard-library.url = "path:./sonic-sysguard-library";
    #sonic-system-info.url = "path:./sonic-system-info";
    sonic-win.url = "path:./sonic-win";
    sonic-workspace.url = "path:./sonic-workspace";
    #sonic-workspace-wallpapers.url = "path:./sonic-workspace-wallpapers";

    # tie everything to ONE nixpkgs since we don't want, say, ninety-nine. hopefully the thingy grok came up with bails us out here.
    #sonic-desktop-interface.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-frameworks-auth.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-frameworks-io.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-frameworks-windowsystem.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-interface-libraries.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-keybind-daemon.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-screen.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-screen-library.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-screenlocker.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-sysguard-library.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-system-info.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-win.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-workspace.inputs.nixpkgs.follows = "nixpkgs";
    #sonic-workspace-wallpapers.inputs.nixpkgs.follows = "nixpkgs";

  };

outputs = {
  self,
  nixpkgs,
  flake-utils,
  sonic-desktop-interface,
  #sonic-frameworks-auth,
  #sonic-frameworks-io,
  #sonic-frameworks-windowsystem,
  #sonic-interface-libraries,
  #sonic-keybind-daemon,
  #sonic-screen,
  #sonic-screen-library,
  #sonic-screenlocker,
  #sonic-sysguard-library,
  #sonic-system-info,
  sonic-win,
  sonic-workspace#,
  #sonic-workspace-wallpapers
  }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

      # all sonic inputs
        sonicInputs = builtins.filterAttrs
        (name: _: builtins.match "sonic-.*" name != null)
        inputs;

      # Apply follows to nixpkgs + flake-utils for every sonic-* input. grok came up with this, hopefully it works :\
      inputsWithFollows = builtins.mapAttrs
        (name: input: input // {
          inputs = {
            nixpkgs.follows = "nixpkgs";
            flake-utils.follows = "flake-utils";
          };
        })
        sonicInputs;

      in
      {

        packages = {

          sonic-desktop-interface = sonic-desktop-interface.packages.${system}.default;
          #sonic-frameworks-auth = sonic-frameworks-auth.packages.${system}.default;
          #sonic-frameworks-io = sonic-frameworks-io.packages.${system}.default;
          #sonic-frameworks-windowsystem = sonic-frameworks-windowsystem.packages.${system}.default;
          #sonic-interface-libraries = sonic-interface-libraries.packages.${system}.default;
          #sonic-keybind-daemon = sonic-keybind-daemon.packages.${system}.default;
          #sonic-screen = sonic-screen.packages.${system}.default;
          #sonic-screen-library = sonic-screen-library.packages.${system}.default;
          #sonic-screenlocker = sonic-screenlocker.packages.${system}.default;
          #sonic-sysguard-library = sonic-sysguard-library.packages.${system}.default;
          #sonic-system-info = sonic-system-info.packages.${system}.default;
          sonic-win = sonic-win.packages.${system}.default;
          sonic-workspace = sonic-workspace.packages.${system}.default;
          #sonic-workspace-wallpapers = sonic-workspace-wallpapers.packages.${system}.default;
          # add more as you create them
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
