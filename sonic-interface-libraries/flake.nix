{
  description = "x11 fork of libplasma, for use in the sonic desktop environment"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-interface-libraries-source = { # FILL
      url = "github:sonic-de/sonic-interface-libraries/6.6.5"; # FILL
      flake = false;
    };

    #dep.url = "path:../dep/";

    sonic-keybind-daemon.url = "path:../sonic-keybind-daemon/";
    sonic-frameworks-io.url = "path:../sonic-frameworks-io/";

  };

  outputs = { self, nixpkgs, flake-utils, sonic-keybind-daemon, sonic-frameworks-io, sonic-interface-libraries-source }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        #Dependency = dep.packages.${system}.default;

        SonicKeybindDaemon = sonic-keybind-daemon.packages.${system}.default;
        SonicFrameworksIO = sonic-frameworks-io.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-interface-libraries"; # FILL
          version = "6.6.5";

          src = sonic-interface-libraries-source; # FILL

          nativeBuildInputs = with pkgs; [
            cmake
            kde.extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook
            python3
            gettext
          ];

          postPatch = ''
            patchShebangs src/plugins/strip-effect-metadata.py
          '';

          buildInputs = with kde; [

            qtbase
            qtdeclarative
            qttools
            qtsvg
            qt5compat
            plasma-activities

            karchive
            kconfig
            kconfigwidgets
            kcoreaddons
            kguiaddons
            ki18n
            kiconthemes
            kxmlgui
            knotifications
            kpackage
            kcmutils
            ksvg

          ] ++ (with qt6; [

          ]) ++ (with pkgs; [

            #Dependency

            SonicKeybindDaemon
            SonicFrameworksIO

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "x11 fork of libplasma, for use in the sonic desktop environment"; # FILL
            homepage = "https://github.com/Sonic-DE/sonic-interface-libraries"; # FILL
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
