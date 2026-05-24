{
  description = "System Info Viewer for SonicDE"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-system-info-source = { # FILL
      url = "github:sonic-de/sonic-system-info/6.6.5"; # FILL
      flake = false;
    };

    #dep.url = "path:../dep/";
    sonic-frameworks-io.url = "path:../sonic-frameworks-io";
    sonic-frameworks-core-addons.url = "path:../sonic-frameworks-core-addons";
    sonic-frameworks-auth.url = "path:../sonic-frameworks-auth";

  };

  outputs = { self, nixpkgs, flake-utils, /*dep,*/ sonic-system-info-source, sonic-frameworks-io, sonic-frameworks-core-addons, sonic-frameworks-auth }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        #Dependency = dep.packages.${system}.default;
        SonicFrameworksIO = sonic-frameworks-io.packages.${system}.default;
        SonicFrameworksCoreAddons = sonic-frameworks-core-addons.packages.${system}.default;
        SonicFrameworksAuth = sonic-frameworks-auth.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-system-info"; # FILL
          version = "6.6.5";

          src = sonic-system-info-source; # FILL

          nativeBuildInputs = with pkgs; [
            cmake
            kde.extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook
            python3
          ];

          preConfigure = ''
            # Force kauth helpers to install into this package instead of sonic-frameworks-auth
            substituteInPlace kcms/helpers/dmidecode-helper/CMakeLists.txt \
              --replace 'KAUTH_HELPER_INSTALL_DIR' 'CMAKE_INSTALL_PREFIX/libexec/kf6/kauth' || true
          '';

          preFixup = ''
            # Fix dangling kinfocenter symlink (points to systemsettings from KDE)
            # taken from https://github.com/NixOS/nixpkgs/blob/master/pkgs/kde/plasma/kinfocenter/default.nix
            ln -sf ${pkgs.kdePackages.systemsettings}/bin/systemsettings $out/bin/kinfocenter
            # this line might be a bad idea, because I don't know how it will depend on whether or not
            # systemsettings is installed, and other little details
          '';

          postPatch = ''
            patchShebangs src/plugins/strip-effect-metadata.py
          '';

          postInstall = ''
            mkdir -p $out/libexec/kf6/kauth
            mv $out/libexec/kinfocenter-dmidecode-helper $out/libexec/kf6/kauth/ 2>/dev/null || true
            ln -s systemsettings $out/bin/kinfocenter || true
          '';

          buildInputs = with kde; [

            qtbase
            qtdeclarative
            qttools
            qt5compat

            ki18n
            kcompletion
            kconfig
            kconfigwidgets
            kdbusaddons
            kdeclarative
            kiconthemes
            kcmutils
            kservice
            solid
            kwidgetsaddons
            kxmlgui

          ] ++ (with qt6; [

          ]) ++ (with pkgs; [

            libglvnd
            mesa
            libdrm
            pciutils
            libusb1
            udev
            vulkan-headers
            vulkan-tools
            fwupd
            aha
            clinfo

            xdpyinfo
            mesa-demos
            dmidecode

            #Dependency
            SonicFrameworksIO
            SonicFrameworksCoreAddons
            SonicFrameworksAuth

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            "-DKAUTH_HELPER_INSTALL_DIR=libexec/kf6/kauth"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "System Info Viewer for SonicDE"; # FILL
            homepage = "https://github.com/Sonic-DE/sonic-system-info"; # FILL
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
