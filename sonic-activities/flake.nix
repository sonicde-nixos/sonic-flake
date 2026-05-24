{
  description = "Provides the infrastructure needed to manage a user's activities"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-activities-source = { # FILL
      url = "github:sonic-de/sonic-activities/6.6.5"; # FILL
      flake = false;
    };

    #dep.url = "path:../dep/";

  };

  outputs = { self, nixpkgs, flake-utils, /*dep,*/ sonic-activities-source }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        #Dependency = dep.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-activities"; # FILL
          version = "6.6.5";

          src = sonic-activities-source; # FILL

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
            kconfig
            kcoreaddons

          ] ++ (with qt6; [

          ]) ++ (with pkgs; [

            #Dependency

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = "Provides the infrastructure needed to manage a user's activities"; # FILL
            homepage = "https://github.com/Sonic-DE/sonic-activities"; # FILL
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
