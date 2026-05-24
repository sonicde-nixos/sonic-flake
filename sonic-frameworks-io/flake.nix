#TODO:
#
#SonicFrameworksAuth
#SonicFrameworksWindowSystem

{
  description = "framework for handling input"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-frameworks-io-source = {
      url = "github:sonic-de/sonic-frameworks-io/6.26.0"; # FILL
      flake = false;
    };

    sonic-frameworks-auth.url = "path:../sonic-frameworks-auth/";

  };

  outputs = { self, nixpkgs, flake-utils, sonic-frameworks-io-source, sonic-frameworks-auth }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        SonicFrameworksAuth = sonic-frameworks-auth.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-frameworks-io"; # FILL
          version = "6.26.0";

          src = sonic-frameworks-io-source;

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

            qtbase
            qtdeclarative
            qttools
            qt5compat
            qtshadertools

            solid
            kcrash
            kcmutils
            kbookmarks
            kjobwidgets
            ktextwidgets
            kservice
            kdoctools
            kdbusaddons
            kcompletion
            kwallet
            knotifications
            kded
            #kauth
            kwindowsystem
            kxmlgui
            kconfig
            kcoreaddons
            ki18n
            kwidgetsaddons

          ] ++ (with pkgs; [

            acl
            attr
            zlib
            libxml2
            libxslt
            krb5

            libx11
            libxcb
            libxkbcommon

            SonicFrameworksAuth

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "framework for handling input"; # FILL
            homepage = "https:/sonic-frameworks-io/github.com/Sonic-DE/sonic-frameworks-io"; # FILL
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

