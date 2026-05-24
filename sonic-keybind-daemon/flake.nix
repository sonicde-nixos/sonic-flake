#TODO:
#
#SonicFrameworksIO
#SonicFrameworksWindowSystem

{
  description = "Daemon for handling keybinds in sonic-DE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-keybind-daemon-source = {
      url = "github:sonic-de/sonic-keybind-daemon/6.6.5";
      flake = false;
    };

    sonic-frameworks-io.url = "path:../sonic-frameworks-io/";

  };

  outputs = { self, nixpkgs, flake-utils, sonic-keybind-daemon-source, sonic-frameworks-io }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        SonicFrameworksIO = sonic-frameworks-io.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-keybind-daemon";
          version = "6.6.5";

          src = sonic-keybind-daemon-source;

          nativeBuildInputs = with pkgs; [
            cmake
            kde.extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook
            python3
            doxygen
          ];

          postPatch = ''
            patchShebangs src/plugins/strip-effect-metadata.py
          '';

          buildInputs = with kde; [

            kconfig
            kcoreaddons
            kdbusaddons
            ki18n
            knotifications
            kservice
            kglobalaccel
            kwindowsystem
            #kio
            kxmlgui
            kcmutils
            plasma-activities
            kstatusnotifieritem
            kded

          ] ++ (with qt6; [

            qtbase
            qtdeclarative
            qtsvg
            qttools
            qt5compat
            #qtquick
            qtshadertools
            qtsensors
            #qtdbus
            #qtnetwork

          ]) ++ (with pkgs; [

            libx11
            libxcb
            libxcb-util
            libxcb-keysyms
            xcbutilxrm
            libxkbcommon
            libxext

            SonicFrameworksIO

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "Daemon for handling keybinds in sonic-DE";
            homepage = "https://github.com/Sonic-DE/sonic-keybind-daemon";
            license = licenses.gpl2Plus;
            platforms = platforms.linux;
            mainProgram = "";
          };
        };

        apps.default = {
          type = "app";
          program = "${packages.default}/bin/";
        };

        /*devShells.default = pkgs.mkShell {
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
