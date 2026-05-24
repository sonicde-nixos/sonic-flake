{
  description = "Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of Sonic-DE!"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    silver-theme-source = { # FILL
      url = "github:sonic-de/silver-theme/6.6.0"; # FILL
      flake = false;
    };

    #dep.url = "path:../dep/";

  };

  outputs = { self, nixpkgs, flake-utils, /*dep,*/ silver-theme-source }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        #Dependency = dep.packages.${system}.default;

      in rec {
        # taken and modified from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/kl/klassy/package.nix#L62
        packages.default = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "silver-theme";
          version = "6.6.0";

          src = silver-theme-source;

          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            kdePackages.extra-cmake-modules
            kdePackages.wrapQtAppsHook
          ];

          buildInputs = with kde; [
            qtbase
            qtdeclarative
            qttools
            qtsvg

            frameworkintegration
            kcmutils
            kcolorscheme
            kconfig
            kcoreaddons
            kdecoration
            kguiaddons
            ki18n
            kiconthemes
            kirigami
            kwidgetsaddons
            kwindowsystem
          ];

          # Silver is intended for qt6! It's possible to change this if you would like.
          cmakeFlags = [
            (pkgs.lib.cmakeBool "BUILD_QT6" true)
            (pkgs.lib.cmakeBool "BUILD_QT5" false)
          ];

          #passthru.updateScript = gitUpdater {
          #  rev-prefix = "v";
          #};

          meta = {
            description = "Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of Sonic-DE!";
            homepage = "https://github.com/Sonic-DE/silver-theme";
            platforms = pkgs.lib.platforms.linux;
            license = with pkgs.lib.licenses; [
              bsd3
              cc0
              gpl2Only
              gpl2Plus
              gpl3Only
              gpl3Plus
              mit
            ];
            mainProgram = "silver-settings";
          };
        });

        apps.default = {
          type = "app";
          program = "${packages.default}/bin/"; # FILL
        };

        /*devShells.default = pkgs.mkShell {      # uncomment if you want to, ig
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            kde.qtcreator
            gdb
            renderdoc
            nix-output-monitor
            just
          ];
          shellHook = ''
            echo ""
          '';
        };*/
      }
    );
}
