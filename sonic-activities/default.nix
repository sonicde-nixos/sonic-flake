{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

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
    description = "Provides the infrastructure needed to manage a user's activities";
    homepage = "https://github.com/sonic-DE/sonic-activities";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "plasma-activities-cli6";
  };
}