{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
    libcanberra
    pulseaudio
    libsysprof-capture
  ] 
  ++ (with pkgs.kdePackages; [
    qttools
    kconfig
    kdeclarative
    kstatusnotifieritem
    ki18n
    kcmutils
    ksvg
    kdbusaddons
    kpackage
    pulseaudio-qt
    kirigami-addons
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
    sonic-frameworks-core-addons
    sonic-frameworks-keybind
    sonic-interface-libraries
  ]);

  propagatedDependencies = with pkgs; [
    sound-theme-freedesktop
    kdePackages.kirigami-addons
    kdePackages.kitemmodels
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Applet to manage your audio on Sonic-DE!";
    homepage = "https://github.com/Sonic-DE/sonic-audio-applet-pulse";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}