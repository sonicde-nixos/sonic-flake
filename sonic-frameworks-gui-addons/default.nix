{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    qtdeclarative
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = true;

  meta = {
    description = "Utilities for graphical user interfaces on Sonic-DE!";
    homepage = "https://github.com/Sonic-DE/sonic-frameworks-gui-addons";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "kde-geo-uri-handler";
  };
}