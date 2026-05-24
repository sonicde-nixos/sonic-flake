{
  description = "lots of addons to improve your sonic experience!"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-workspace-addons-source = { # FILL
      url = "github:sonic-de/sonic-workspace-addons/6.6.5"; # FILL
      flake = false;
    };

    #dep.url = "path:../dep/";
    sonic-frameworks-io.url = "path:../sonic-frameworks-io";

  };

  outputs = { self, nixpkgs, flake-utils, sonic-frameworks-io, sonic-workspace-addons-source }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        SonicFrameworksIO = sonic-frameworks-io.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-workspace-addons"; # FILL
          version = "6.6.5";

          src = sonic-workspace-addons-source; # FILL

          nativeBuildInputs = with pkgs; [
            cmake
            kde.extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook
            python3
          ];

          postPatch = ''
            patchShebangs src/plugins/strip-effect-metadata.py
          '';

          buildInputs = with kde; [

            qtbase
            qtdeclarative
            qttools
            qt5compat
            qtwebengine
            qtpositioning

            krunner
            kdeclarative
            knotifications
            kdnssd
            kdoctools
            kdbusaddons
            kconfigwidgets
            kiconthemes
            #kio
            solid
            kcmutils
            ksvg
            knewstuff
            kholidays
            sonnet
            kunitconversion
            networkmanager-qt
            plasma5support
            libplasma

            qtquick3d
            kirigami-addons

          ] ++ (with qt6; [

          ]) ++ (with pkgs; [

            #Dependency
            SonicFrameworksIO

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "lots of addons to improve your sonic experience!"; # FILL
            homepage = "https://github.com/Sonic-DE/sonic-workspace-addons"; # FILL
            license = licenses.gpl2Plus; # FILL, most likely licenses.gpl2Plus
            platforms = platforms.linux;
            mainProgram = ""; # FILL
          };
        };

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
