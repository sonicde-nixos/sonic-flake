{
  description = "sonic-desktop-interface - an x11 focused fork of KDE's interface";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-desktop-interface-source = {
      url = "github:sonic-de/sonic-desktop-interface/6.6.3";
      flake = false;
    };

    sonic-win.url = "path:../sonic-win/";
    sonic-workspace.url = "path:../sonic-workspace/";

    #TODO:
    #
    #SonicDELibksysguard
    #SonicFrameworksAuth
    #SonicFrameworksWindowSystem
    #SonicFrameworksIO
    #sonic-framework-common
  };

  outputs = { self, nixpkgs, flake-utils, sonic-win, sonic-workspace, sonic-desktop-interface-source }:
  #outputs = { self, nixpkgs, flake-utils, sonic-win }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        kde = pkgs.kdePackages;
        #qt6 = pkgs.libsForQt5;
        qt6 = pkgs.qt6;

        sonicWorkspace = sonic-workspace.packages.${system}.default;

        sonicWin = sonic-win.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-desktop-interface";
          version = "unstable-2026-02";

          src = sonic-desktop-interface-source;

          nativeBuildInputs = with pkgs; [
            cmake
            extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook
            python3Minimal
          ];

          postPatch = ''
            # Fix common shebang issues in Plasma workspace plugins/effects
            patchShebangs .
            substituteInPlace CMakeLists.txt \
              --replace 'find_package(KWinDBusInterface CONFIG REQUIRED)' \
                        'find_package(KWinX11DBusInterface CONFIG REQUIRED)'
          '';

          propagatedBuildInputs = [
            sonicWin  # Ensures files from sonic-win are in the sandbox at build time
            # grok said add it :\
          ];

          buildInputs = with kde; [

            qtbase
            qtdeclarative
            qtsvg
            #qtwayland
            qt5compat
            qttools
            qtsensors
            qt6.qtlocation
            qcoro

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

            # ── newly added to fix current error ──
            kde.kauth
            kidletime
            ksvg

            kitemmodels
            kded
            knotifyconfig
            prison
            kstatusnotifieritem

            krunner
            ktexteditor
            plasma5support
            #kwayland
            plasma-activities
            plasma-activities-stats
            baloo

            knighttime
            kdecoration

            kde.kscreenlocker

            kirigami
            kirigami-addons

            kaccounts-integration
            qtwebengine

          ] ++ (with qt6; [
            #qtquickcontrols2

            qtshadertools
            #qtwebengine

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

            sonicWin

            libxft
            libsm
            phonon
            libqalculate

            libwacom
            SDL2
            libgudev
            xkeyboard-config

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            "-DCMAKE_PREFIX_PATH=${sonicWorkspace};${sonicWin}"
            "-DBUILD_KCM_MOUSE_X11=OFF"
            "-DBUILD_KCM_TOUCHPAD_X11=OFF"
          ];

          meta = with pkgs.lib; {
            description = "Customized Plasma workspace/shell with X11 emphasis";
            homepage = "https://github.com/Sonic-DE/sonic-workspace";
            license = licenses.gpl2Plus;
            platforms = platforms.linux;
            # mainProgram = "plasmashell";   # uncomment if you want nix run → plasmashell
          };
        };

        apps.default = {
          type = "app";
          program = "${packages.default}/bin/plasmashell";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            kde.qtcreator
            gdb
            nix-output-monitor
            just
            ccls
          ];
          shellHook = ''
            echo "sonic-desktop-interface – Plasma 6 / KF6 / Qt6 ready"
          '';
        };
      }
    );
}
