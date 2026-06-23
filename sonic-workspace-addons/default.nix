{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qttools
    qt5compat
    qtwebengine
    qtpositioning

    krunner
    kdeclarative
    knotifications
    kdnssd
    kdoctools
    kdbusaddons
    kconfigwidgets
    kiconthemes
    #kio
    solid
    kcmutils
    ksvg
    knewstuff
    kholidays
    sonnet
    kunitconversion
    networkmanager-qt
    plasma5support
    libplasma

    qtquick3d
    kirigami-addons
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-io
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "All kind of add-ons to improve your Sonic experience.";
    homepage = "https://github.com/Sonic-DE/sonic-workspace-addons";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}