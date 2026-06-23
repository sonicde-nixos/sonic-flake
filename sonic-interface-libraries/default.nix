{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    ./rb-extracomponents.patch
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    qtdeclarative
    qttools
    qtsvg
    qt5compat
    plasma-activities

    karchive
    kconfig
    kconfigwidgets
    kcoreaddons
    kguiaddons
    ki18n
    kiconthemes
    kxmlgui
    knotifications
    kpackage
    kcmutils
    ksvg
  ])
  ++ (with Sonic-DE; [
    sonic-keybind-daemon
    sonic-frameworks-io
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "x11 focused fork of libplasma, for use in the sonic desktop environment";
    homepage = "https://github.com/Sonic-DE/sonic-interface-libraries";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}