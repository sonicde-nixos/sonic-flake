{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    kconfig
    ki18n
    kwindowsystem
    kitemmodels
  ])
  ++ (with Sonic-DE; [
    sonic-activities
    sonic-frameworks-cmake-modules
    sonic-frameworks-core-addons
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    kdePackages.kconfig
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "A handy tool to run your programs on Sonic-DE!";
    homepage = "https://github.com/Sonic-DE/sonic-frameworks-runner";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}