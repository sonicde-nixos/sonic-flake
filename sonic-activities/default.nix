{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
    boost
  ] 
  ++ (with pkgs.kdePackages; [
    qtdeclarative
    kconfig
    kcoreaddons
  ])
  ++ (with Sonic-DE; [
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Provides the infrastructure needed to manage a user's activities";
    homepage = "https://github.com/Sonic-DE/sonic-activities";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "plasma-activities-cli6";
  };
}