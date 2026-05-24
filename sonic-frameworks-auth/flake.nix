#TODO:
#
#SonicFrameworksWindowSystem

{
  description = "frameworks for authorization"; # FILL

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sonic-frameworks-auth-source = { # FILL
      url = "github:sonic-de/sonic-frameworks-auth/6.26.0"; 
      flake = false;
    };

    #dep.url = "path:../dep/";

  };

  outputs = { self, nixpkgs, flake-utils, /*dep,*/ sonic-frameworks-auth-source }: # FILL
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kde = pkgs.kdePackages;

        qt6 = pkgs.qt6;

        #Dependency = dep.packages.${system}.default;

      in rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "sonic-frameworks-auth"; # FILL
          version = "6.26.0";

          src = sonic-frameworks-auth-source; # FILL

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
            substituteInPlace CMakeLists.txt \
              --replace 'KAUTH_INSTALL_HELPER_DIR' 'CMAKE_INSTALL_FULL_LIBEXECDIR' \
              --replace 'libexec/kauth' 'libexec' || true
          '';

          buildInputs = with kde; [

            qtbase
            qtdeclarative
            qttools
            qt5compat

            kcoreaddons
            kwindowsystem

          ] ++ (with qt6; [

          ]) ++ (with pkgs; [

            #Dependency

          ]);

          cmakeFlags = [
            "-DBUILD_TESTING=OFF"
            "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
            "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
            #"KAUTH_POLICY_FILES_INSTALL_DIR \"${KDE_INSTALL_DATADIR}/polkit-1/actions\"" # from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/kde/frameworks/kauth/fix-paths.patch
            #"KAUTH_HELPER_INSTALL_DIR \"${KDE_INSTALL_LIBEXECDIR}\""
            #"KAUTH_HELPER_INSTALL_ABSOLUTE_DIR \"${KDE_INSTALL_LIBEXECDIR}\""
            # "-DWITH_WAYLAND=OFF"
          ];

          meta = with pkgs.lib; {
            description = ""; # FILL
            homepage = "https://github.com/Sonic-DE/sonic-frameworks-auth"; # FILL
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
