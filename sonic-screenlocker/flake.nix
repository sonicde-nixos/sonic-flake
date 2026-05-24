{
  description = "sonic-screenlocker, an x11 only screenlocker for sonic-DE";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-screenlocker = {
      url = "github:sonic-de/sonic-screenlocker/6.6.5.2";
      flake = false;
    };

    #TODO:
    #
    # SonicDEKeybindDaemon
    # SonicDEScreen
    # SonicFrameworksIO

    sonic-keybind-daemon.url = "path:../sonic-keybind-daemon/";
    sonic-frameworks-io.url = "path:../sonic-frameworks-io/";
    sonic-frameworks-auth.url = "path:../sonic-frameworks-auth/";
    sonic-workspace.url = "path:../sonic-workspace/";

  };

  outputs = { self, nixpkgs, flake-utils, sonic-screenlocker, sonic-keybind-daemon, sonic-frameworks-io, sonic-frameworks-auth, sonic-workspace, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = nixpkgs.legacyPackages.${system};
        kde = pkgs.kdePackages;
        qt6 = pkgs.qt6;

        SonicKeybindDaemon = sonic-keybind-daemon.packages.${system}.default;
        SonicFrameworksIO = sonic-frameworks-io.packages.${system}.default;
        SonicFrameworksAuth = sonic-frameworks-auth.packages.${system}.default;
        SonicWorkspace = sonic-workspace.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-screenlocker";
          version = "6.6.5.2";

          #src = ./.;
          src = sonic-screenlocker;

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
            qtsvg
            #qtwayland
            qt5compat
            qttools
            qtsensors

            kconfig
            kcoreaddons
            kcrash
            kdbusaddons
            kglobalaccel
            ki18n
            kiconthemes
            kwindowsystem
            kxmlgui
            kcmutils
            kdeclarative
            knewstuff
            plasma-activities
            kconfigwidgets
            kwidgetsaddons
            kservice
            knotifications

            #kauth
            kidletime
            ksvg

            knighttime
            #kdecoration

            #kscreenlocker

            aurorae
            breeze

            plasma5support
            #plasma-workspace

            libplasma
            kscreen

            kirigami

            #kglobalacceld

          ] ++ (with qt6; [
            #qtquickcontrols2
            qtshadertools
          ]) ++ (with pkgs; [

            pam
            libX11
            libXcomposite
            libXdamage
            libXfixes
            libXrender
            libXrandr
            libXcursor
            libXinerama
            libxkbcommon
            libxcb
            #xcb-util
            #xcb-util-keysyms
            #xcb-util-wm
            #xcb-util-image
            #xcb-util-cursor
            #epoxy
            libdrm
            mesa
            #wayland
            #wayland-protocols
            libinput
            udev

            libcanberra
            libdisplay-info
            lcms2

            expat
            hwdata

            libsm
            libxi
            #libcap
            libei
            pipewire
            fontconfig
            freetype
            appstream
            glib-networking

            vulkan-headers
            vulkan-loader

            libxcvt

            SonicKeybindDaemon
            SonicFrameworksIO
            SonicFrameworksAuth
            SonicWorkspace

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "x11 only screenlocker for sonic DE";
            homepage = "https://github.com/Sonic-DE/sonic-screenlocker";
            license = licenses.gpl2Plus;
            platforms = platforms.linux;
            mainProgram = "kscreenlocker";
          };
        };

        apps.default = {
          type = "app";
          program = "${packages.default}/bin/kscreenlocker";
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
            echo "sonic-screenlocker dev shell"
          '';
        };*/
      }
    );
}
