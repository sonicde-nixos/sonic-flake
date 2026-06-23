{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    kdePackages.qttools
    Sonic-DE.sonic-frameworks-cmake-modules
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Handles your keybinds on Sonic-DE";
    homepage = "https://github.com/Sonic-DE/sonic-frameworks-keybind";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}