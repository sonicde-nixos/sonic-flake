{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
    libx11
    libxcb
    libxcb-util
    libxcb-keysyms
    xcbutilxrm
    libxkbcommon
    libxext
  ] 
  ++ (with pkgs.kdePackages; [
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    knotifications
    kservice
    kglobalaccel
    kwindowsystem
    #kio
    kxmlgui
    kcmutils
    plasma-activities
    kstatusnotifieritem
    kded

    qtbase
    qtdeclarative
    qtsvg
    qttools
    qt5compat
    #qtquick
    qtshadertools
    qtsensors
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
    description = "Daemon for handling keybinds in Sonic-DE";
    homepage = "https://github.com/Sonic-DE/sonic-keybind-daemon";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
}