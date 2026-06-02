{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    qtpositioning
    kconfig
    ki18n
    kcoreaddons
    kdbusaddons
    kholidays
  ])
  ++ (with sonic-DE; [
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Provides helpers for scheduling the day-night cycle.";
    homepage = "https://github.com/sonic-DE/sonic-night-light";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}