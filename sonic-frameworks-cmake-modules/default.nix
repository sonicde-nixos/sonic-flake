{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  outputs = [ "out" ];

  setupHook = ./ecm-hook.sh;

  patches = [
    ./search-qml.patch
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    qttools
  ])
  ++ (with Sonic-DE; [
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    sphinx
  ];

  # taken from https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/kde/frameworks/extra-cmake-modules/default.nix
  # Packages that have an Android APK require Python3 at build time.
  # See: https://invent.kde.org/frameworks/extra-cmake-modules/-/blob/v6.1.0/modules/ECMAddAndroidApk.cmake?ref_type=tags#L57
  propagatedNativeBuildInputs = with pkgs; [
    python3
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Extra Cmake Modules for Sonic-DE";
    homepage = "https://github.com/Sonic-DE/sonic-frameworks-cmake-modules";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.all; # Pure CMake macros, also used by non-KDE packages on all platforms.
  };
}