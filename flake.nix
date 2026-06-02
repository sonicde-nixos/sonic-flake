{
  description = "Sonic-DE flake with multiple packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    
    silver-theme = {
      url = "github:sonic-DE/silver-theme/6.6.0";
      flake = false;
    };

    sonic-activities = {
      url = "github:sonic-DE/sonic-activities/6.6.5";
      flake = false;
    };

    sonic-decoration = {
      url = "github:sonic-DE/sonic-decoration/6.6.5";
      flake = false;
    };

    sonic-desktop-interface = {
      url = "github:sonic-DE/sonic-desktop-interface/6.6.5";
      flake = false;
    };
    
    sonic-frameworks-auth = {
      url = "github:sonic-DE/sonic-frameworks-auth/6.26.0";
      flake = false;
    };

    sonic-frameworks-core-addons = {
      url = "github:sonic-DE/sonic-frameworks-core-addons/6.26.0";
      flake = false;
    };

    sonic-frameworks-io = {
      url = "github:sonic-DE/sonic-frameworks-io/6.26.0";
      flake = false;
    };

    sonic-interface-libraries = {
      url = "github:sonic-DE/sonic-interface-libraries/6.6.5";
      flake = false;
    };

    sonic-keybind-daemon = {
      url = "github:sonic-DE/sonic-keybind-daemon/6.6.5";
      flake = false;
    };

    sonic-night-light = {
      url = "github:sonic-DE/sonic-night-light/6.6.5";
      flake = false;
    };

    sonic-screenlocker = {
      url = "github:sonic-DE/sonic-screenlocker/6.6.5";
      flake = false;
    };

    sonic-sysguard-library = {
      url = "github:sonic-DE/sonic-sysguard-library/6.6.5";
      flake = false;
    };

    sonic-system-info = {
      url = "github:sonic-DE/sonic-system-info/6.6.5";
      flake = false;
    };

    sonic-win = {
      url = "github:sonic-DE/sonic-win/6.6.5";
      flake = false;
    };

    sonic-workspace = {
      url = "github:sonic-DE/sonic-workspace/6.6.5";
      flake = false;
    };

    sonic-workspace-addons = {
      url = "github:sonic-DE/sonic-workspace-addons/6.6.5";
      flake = false;
    };

  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    mkSonicDerivation = (import ./lib/mk-sonic-drv.nix self) {
      inherit (pkgs)
        lib
        stdenv
        makeSetupHook
        cmake
        ninja
        qt6
        python3
        python3Packages
        jq;
    };
    
    # automatically list subdirectories that have default.nix
    pkgDirs = builtins.filter (d: builtins.pathExists (./. + "/${d}/default.nix")) (builtins.attrNames inputs);

    sonicVersions = {
      
      silver-theme = "6.6.0";
      sonic-activities = "6.6.5";
      sonic-decoration = "6.6.5";
      sonic-desktop-interface = "6.6.5";
      sonic-frameworks-auth = "6.26.0";
      sonic-frameworks-core-addons = "6.26.0";
      sonic-frameworks-io = "6.26.0";
      sonic-interface-libraries = "6.6.5";
      sonic-keybind-daemon = "6.6.5";
      sonic-night-light = "6.6.5";
      sonic-screenlocker = "6.6.5";
      sonic-sysguard-library = "6.6.5";
      sonic-system-info = "6.6.5";
      sonic-win = "6.6.5";
      sonic-workspace = "6.6.5";
      sonic-workspace-addons = "6.6.5";
    };
  in
  rec {
    packages.${system} = builtins.listToAttrs (
      map (pname:
        let
          src = inputs.${pname};
          version = sonicVersions.${pname};
          sonic-DE = self.packages.${system};
        in
        {
          name = pname;
          value = import (./. + "/${pname}/default.nix") { inherit mkSonicDerivation pkgs pname src version sonic-DE; };
        }
      ) pkgDirs
    );
  };
}
