{
  description = "sonic-win – Lightweight X11-only KWin fork";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    sonic-win-source = {
      url = "github:sonic-de/sonic-win/6.6.3";
      flake = false;
    };

    #sonic-screen-locker.url = "path:../sonic-screen-locker";
    #sonic-frameworks-auth.url = "path:../sonic-frameworks-auth";
    #sonic-keybind-daemon.url = "path:../sonic-keybind-daemon";

    #TODO:
    #
    #sonic-framework-common
  };

  outputs = { self, nixpkgs, flake-utils, sonic-win-source }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        #sonicScreenLocker = sonic-screen-locker.packages.${system}.default;

        #sonicFrameworksAuth = sonic-frameworks-auth.packages.${system}.default;

        #sonicKeybindDaemon = sonic-keybind-daemon.packages.${system}.default;

        #sonicFrameworkCommon = sonic-framework-common.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-win";
          version = "v6.6.3";

          #src = ./.;
          src = sonic-win-source;

          nativeBuildInputs = with pkgs; [
            cmake
            extra-cmake-modules
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

            kde.kauth
            kidletime
            ksvg

            knighttime
            #kdecoration

            kscreenlocker

            aurorae
            breeze

            #plasma5support

            kirigami

            kglobalacceld

          ] ++ (with qt6; [
            #qtquickcontrols2
            qtshadertools
          ]) ++ (with pkgs; [
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



          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "Lightweight X11-only window manager / compositor (KWin fork)";
            homepage = "https://github.com/Sonic-DE/sonic-win";
            license = licenses.gpl2Plus;
            platforms = platforms.linux;
            mainProgram = "kwin_x11";
          };
        };

        apps.default = {
          type = "app";
          program = "${packages.default}/bin/kwin_x11";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            kde.qtcreator
            gdb
            renderdoc
            nix-output-monitor
            just
          ];
          shellHook = ''
            echo "sonic-win dev shell (X11-focused Plasma 6 build env)"
          '';
        };
      }
    );
}
