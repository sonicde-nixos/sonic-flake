{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

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
    extra-cmake-modules
  ])
  ++ (with sonic-DE; [
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    kdePackages.extra-cmake-modules
    shared-mime-info
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = true;

  meta = {
    description = "Qt addon library with a collection of non-GUI utilities for sonic-DE";
    homepage = "https://github.com/sonic-DE/sonic-frameworks-core-addons";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
}