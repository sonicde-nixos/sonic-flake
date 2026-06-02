{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    ./helper-path.patch
  ];

  buildDependencies = with pkgs; [
    libnl
    libpcap
    libcap
    libdrm
    lm_sensors
    zlib

    libx11
    libxkbcommon
  ] 
  ++ (with pkgs.kdePackages; [
    qtdeclarative
    qtwebengine
    qtpositioning
    qt5compat
    qtsensors
    qttools

    kconfig
    ki18n
    kglobalaccel
    kdeclarative
    knewstuff
    #kauth
    kcompletion
    kwidgetsaddons
    kiconthemes
    kconfigwidgets
    kservice
    kjobwidgets
    kdoctools
  ])
  ++ (with sonic-DE; [
    sonic-frameworks-io
    sonic-frameworks-auth
  ]);

  propagatedDependencies = with pkgs; [
    kdePackages.kitemmodels
    kdePackages.kquickcharts
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Sonic-DE system monitoring framework";
    homepage = "https://github.com/sonic-DE/sonic-sysguard-library";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}