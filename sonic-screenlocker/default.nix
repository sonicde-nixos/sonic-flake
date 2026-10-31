{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

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

    # vendor-patch: nixpkgs libplasma 6.8.1 lacks SharedQmlEngine; use the
    # 6.7.1 fork (sonic-interface-libraries, added below) instead
    #libplasma
    # vendor-patch: nixpkgs kscreen-6.8.1 propagates libplasma/libkscreen
    # 6.8.1-dev, which clashes with the 6.7.1 sonic forks; kscreenlocker has
    # no build-time use for the kscreen app
    #kscreen

    kirigami

    #kglobalacceld

    qqc2-breeze-style
  ])
  ++ (with Sonic-DE; [
    sonic-keybind-daemon
    sonic-frameworks-io
    sonic-frameworks-auth
    # vendor-patch: KF6Screen and PlasmaQuick REQUIRED; sonic-workspace entry
    # removed (nothing in the source references it, and it would cycle with
    # plasma-workspace's REQUIRED KScreenLocker find)
    sonic-screen-library
    sonic-interface-libraries
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
    description = "Application to handle screenlocking on Sonic-DE";
    homepage = "https://github.com/Sonic-DE/sonic-screenlocker";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}