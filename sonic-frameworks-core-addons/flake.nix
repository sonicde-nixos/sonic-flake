{
  description = "Qt addon library with a collection of non-GUI utilities for sonicDE"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-frameworks-core-addons-source = { # FILL
      url = "github:sonic-de/sonic-frameworks-core-addons/6.26.0"; # FILL
      flake = false;
    };

    #dep.url = "path:../dep/";

  };

  outputs = { self, nixpkgs, flake-utils, /*dep,*/ sonic-frameworks-core-addons-source }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [  # grok came up with this, and it seems to work. however, I'd rather have this explicitly listed, not in a let ... in block
          build
          setuptools
          pip
          shiboken6
          pyside6
        ]);

        #Dependency = dep.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-frameworks-core-addons"; # FILL
          version = "6.26.0";

          hasPythonBindings = true;

          src = sonic-frameworks-core-addons-source; # FILL

          nativeBuildInputs = with pkgs; [
            cmake
            kde.extra-cmake-modules
            pkg-config
            ninja
            kde.wrapQtAppsHook

            pythonEnv

          ];

          postPatch = ''
            patchShebangs src/plugins/strip-effect-metadata.py
          '';

          buildInputs = with kde; [

          ] ++ (with qt6; [

            qtbase
            qtdeclarative
            qttools
            qt5compat

          ]) ++ (with pkgs; [

            python3.pkgs.shiboken6
            python3.pkgs.pyside6

            udev
            shared-mime-info

            #Dependency

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "Qt addon library with a collection of non-GUI utilities for sonicDE"; # FILL
            homepage = "https://github.com/Sonic-DE/sonic-frameworks-core-addons"; # FILL
            license = licenses.gpl2Plus; # FILL, most likely licenses.gpl2Plus
            platforms = platforms.linux;
          };
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
