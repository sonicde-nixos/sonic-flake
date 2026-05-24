#TODO:
#
#sonicFrameworksAuth
#sonicFrameworksIO

{
  description = "SonicDE Frameworks 6 system monitoring framework"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-sysguard-library-source = {
      url = "github:sonic-de/sonic-sysguard-library/6.6.5"; # FILL
      flake = false;
    };

    sonic-frameworks-io.url = "path:../sonic-frameworks-io/";
    sonic-frameworks-auth.url = "path:../sonic-frameworks-auth/";

  };

  outputs = { self, nixpkgs, flake-utils, sonic-frameworks-io, sonic-frameworks-auth, sonic-sysguard-library-source }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        sonicFrameworksIO = sonic-frameworks-io.packages.${system}.default;
        sonicFrameworksAuth = sonic-frameworks-auth.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-sysguard-library"; # FILL
          version = "6.6.5";

          src = sonic-sysguard-library-source; # FILL

          nativeBuildInputs = with pkgs; [
            cmake
            kde.extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook
            python3
            gettext
            doxygen
          ];

          postPatch = ''
            patchShebangs src/plugins/strip-effect-metadata.py

            substituteInPlace processcore/CMakeLists.txt \
              --replace-fail 'KAUTH_INSTALL_HELPER_DIR' 'CMAKE_INSTALL_LIBEXECDIR' \
              --replace-fail 'libexec/kauth' 'libexec' \
              --replace-fail 'kf6/kauth' 'libexec' || true
          '';

          buildInputs = with kde; [

            qtbase
            qtdeclarative
            qtwebengine
            qtpositioning
            qt5compat
            qtsensors
            qttools

            kconfig
            ki18n
            kglobalaccel
            kdeclarative
            knewstuff
            #kauth
            kcompletion
            kwidgetsaddons
            kiconthemes
            kconfigwidgets
            kservice
            kjobwidgets
            kdoctools

          ] ++ (with qt6; [

          ]) ++ (with pkgs; [

            libnl
            libpcap
            libcap
            libdrm
            lm_sensors
            zlib

            libx11
            libxkbcommon

            sonicFrameworksIO
            sonicFrameworksAuth

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKAUTH_HELPER_INSTALL_DIR=libexec"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "SonicDE Frameworks 6 system monitoring framework"; # FILL
            homepage = "https://github.com/Sonic-DE/sonic-"; # FILL
            license = licenses.gpl2Plus;
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
