{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    ki18n
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
    description = "Plugin based library to create window decorations for use in sonic-DE";
    homepage = "https://github.com/sonic-DE/sonic-decorations";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
}