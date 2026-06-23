{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
    udev
    shared-mime-info
  ] 
  ++ (with pkgs.kdePackages; [
    qtdeclarative
    qttools
    qt5compat
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    Sonic-DE.sonic-frameworks-cmake-modules
    shared-mime-info
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = true;

  meta = {
    description = "Qt addon library with a collection of non-GUI utilities for Sonic-DE";
    homepage = "https://github.com/Sonic-DE/sonic-frameworks-core-addons";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
}