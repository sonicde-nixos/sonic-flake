{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    # this patch has been modified to remove all wayland references
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
  ];

  postPatch = ''
    patchShebangs src/plugins/strip-effect-metadata.py
  '';

  dontQmlLint = true;

  buildDependencies = with pkgs; [
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
    git
  ] 
  ++ (with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qtsvg
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

    kscreenlocker

    aurorae
    breeze

    #plasma5support

    kirigami

    qtshadertools

    libqaccessibilityclient
    qtquick3d
  ])
  ++ (with sonic-DE; [
    sonic-frameworks-auth
    sonic-keybind-daemon
    sonic-interface-libraries
    sonic-decoration
    sonic-night-light
  ]);

  propagatedDependencies = with pkgs; [
    kdePackages.kirigami
    kdePackages.aurorae
    hwdata
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
    python3
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "An x11 focused fork of kwin, used in Sonic-DE";
    homepage = "https://github.com/sonic-DE/sonic-win";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "kwin_x11";
  };
}