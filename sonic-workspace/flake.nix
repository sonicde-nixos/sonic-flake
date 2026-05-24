{
  description = "sonic-workspace – Custom Plasma workspace components with X11 focus";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-workspace-source = {
      url = "github:sonic-de/sonic-workspace/6.6.5";
      flake = false;
    };

    sonic-win.url = "path:../sonic-win/";
    sonic-frameworks-io.url = "path:../sonic-frameworks-io/";
    sonic-frameworks-auth.url = "path:../sonic-frameworks-auth/";
    sonic-decoration.url = "path:../sonic-decoration/";
    sonic-interface-libraries.url = "path:../sonic-interface-libraries/";
    sonic-activities.url = "path:../sonic-activities/";

  };

  outputs = { self, nixpkgs, flake-utils, sonic-win, sonic-frameworks-io, sonic-frameworks-auth, 
              sonic-workspace-source, sonic-decoration, sonic-interface-libraries, sonic-activities }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        kde = pkgs.kdePackages;
        qt6 = pkgs.qt6;

        sonicWin = sonic-win.packages.${system}.default;
        sonicFrameworksIO = sonic-frameworks-io.packages.${system}.default;
        sonicFrameworksAuth = sonic-frameworks-auth.packages.${system}.default;
        sonicDecoration = sonic-decoration.packages.${system}.default;
        sonicInterfaceLibraries = sonic-interface-libraries.packages.${system}.default;
        sonicActivities = sonic-activities.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-workspace";
          version = "6.6.5";

          src = sonic-workspace-source;

          nativeBuildInputs = with pkgs; [
            cmake
            kde.extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook
            python3Minimal              # for any metadata / generation scripts
          ];

          postPatch = ''
            # Fix common shebang issues in Plasma workspace plugins/effects
            patchShebangs .
            substituteInPlace CMakeLists.txt \
              --replace 'find_package(KWinDBusInterface CONFIG REQUIRED)' \
                        'find_package(KWinX11DBusInterface CONFIG REQUIRED)'
          '';

          outputs = [ "out" "sessions" ];

          # taken from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/kde/plasma/plasma-workspace/default.nix
          postFixup = ''
            
            mkdir -p $out/nix-support
            echo "${pkgs.lsof} ${pkgs.xmessage} ${pkgs.xrdb}" > $out/nix-support/depends

            moveToOutput share/xsessions $sessions

          '';

          passthru = {
            providedSessions = [ "plasmax11" ];
            #sessions = "${placeholder "out"}/share/xsessions";
          };

          qtWrapperArgs = [ "--inherit-argv0" ];

          # taken from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/kde/plasma/plasma-workspace/default.nix
          postInstall = ''
            # Prevent patching this shell file, it only is used by sourcing it from /bin/sh.
            chmod -x $out/libexec/plasma-sourceenv.sh
          '';

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

            #kauth
            kidletime
            ksvg

            kitemmodels
            kded
            knotifications
            knotifyconfig
            prison
            kstatusnotifieritem

            krunner
            ktexteditor
            plasma5support
            kwayland
            plasma-activities
            plasma-activities-stats
            baloo

            knighttime
            #kdecoration

            kde.kscreenlocker

            #kio
            kfilemetadata

            solid
            networkmanager-qt

            ktextwidgets

            kwallet

            kpeople

            kirigami
            kirigami-addons

            plasma5support

            libkexiv2
            kpipewire

            appstream-qt
            packagekit-qt
            #layer-shell-qt

            phonon
            kscreen
            kholidays

            kquickcharts
            kqtquickcharts

            kunitconversion

            kuserfeedback

            kirigami

            plasma-activities-stats

            #breeze
            #plasma-workspace-wallpapers

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
            libxcb-cursor
            libxcb-util
            libxcb-image
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
            #libinput
            udev

            libcanberra
            libdisplay-info
            lcms2

            libxft
            libsm
            libqalculate

            isocodes
            libisocodes
            #libnma
            pipewire

            libXtst

            #libsForQt5.kirigami2
            libsForQt5.polkit-qt

            accountsservice

            lsof
            xmessage
            xrdb

            sonicWin
            sonicFrameworksIO
            sonicFrameworksAuth
            sonicDecoration
            sonicInterfaceLibraries
            sonicActivities

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
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
            echo "sonic-workspace dev shell – Plasma 6 / KF6 / Qt6 ready"
          '';
        };
      }
    );
}
