{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
  ];

  buildDependencies = with pkgs; [
    pam
    libX11
    libXcomposite
    libXdamage
    libXfixes
    libXrender
    libXrandr
    libXcursor
    libXinerama
    libxkbcommon
    libxcb
    #xcb-util
    #xcb-util-keysyms
    #xcb-util-wm
    #xcb-util-image
    #xcb-util-cursor
    #epoxy
    libdrm
    mesa
    #wayland
    #wayland-protocols
    libinput
    udev

    libcanberra
    libdisplay-info
    lcms2

    expat
    hwdata

    libsm
    libxi
    #libcap
    libei
    pipewire
    fontconfig
    freetype
    appstream
    glib-networking

    vulkan-headers
    vulkan-loader

    libxcvt
    elogind
    
  ] 
  ++ (with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qtsvg
    #qtwayland
    qt5compat
    qttools
    qtsensors

    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    ki18n
    kiconthemes
    kwindowsystem
    kxmlgui
    kcmutils
    kdeclarative
    knewstuff
    plasma-activities
    kconfigwidgets
    kwidgetsaddons
    kservice
    knotifications

    #kauth
    kidletime
    ksvg

    knighttime
    #kdecoration

    #kscreenlocker

    aurorae
    breeze

    plasma5support
    #plasma-workspace

    libplasma
    kscreen

    kirigami

    #kglobalacceld

    qqc2-breeze-style
  ])
  ++ (with sonic-DE; [
    sonic-keybind-daemon
    sonic-frameworks-io
    sonic-frameworks-auth
    sonic-workspace
  ]);

  propagatedDependencies = with pkgs; [
    elogind
  ];

  extraNativeBuildInputs = with pkgs; [
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Application to handle screenlocking on sonic-DE";
    homepage = "https://github.com/sonic-DE/sonic-screenlocker";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}