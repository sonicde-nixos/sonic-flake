{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation (
let
  gsettings-wrapper = pkgs.runCommandLocal "gsettings-wrapper" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.glib}/bin/gsettings $out/bin/gsettings --prefix XDG_DATA_DIRS : ${pkgs.gsettings-desktop-schemas.out}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}
  '';
in
{

  inherit pname src version;

  qtWrapperArgs = [ "--prefix PATH : ${pkgs.lib.makeBinPath [ gsettings-wrapper ]}" ];

  patches = [
    (pkgs.replaceVars ./hwclock-path.patch {
      hwclock = "${pkgs.lib.getBin pkgs.util-linux}/bin/hwclock";
    })
    (pkgs.replaceVars ./kcm-access.patch {
      gsettings = "${gsettings-wrapper}/bin/gsettings";
    })
    ./tzdir.patch
    #./no-discover-shortcut.patch  # appears to have already been done?
    (pkgs.replaceVars ./wallpaper-paths.patch {
      wallpapers = "${pkgs.lib.getBin pkgs.kdePackages.breeze}/share/wallpapers";
    })
  ];

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
    #xcb-util
    #xcb-util-keysyms
    #xcb-util-wm
    #xcb-util-image
    #xcb-util-cursor
    #epoxy
    libdrm
    mesa
    libinput
    udev

    libcanberra
    libdisplay-info
    lcms2

    libxft
    libsm
    #phonon
    libqalculate

    libwacom
    SDL2
    libgudev
    xkeyboard-config

    glib
    libsysprof-capture

    ibus

    xf86-input-libinput
    xf86-input-evdev
    xorg-server

    noto-fonts-color-emoji
    
  ] 
  ++ (with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qtsvg
    #qtwayland
    qt5compat
    qttools
    qtsensors
    qtlocation
    qcoro

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

    kauth
    kidletime
    ksvg

    kitemmodels
    kded
    knotifyconfig
    prison
    kstatusnotifieritem

    krunner
    ktexteditor
    plasma5support
    #kwayland
    plasma-activities
    plasma-activities-stats
    baloo

    knighttime
    kdecoration

    kscreenlocker

    kirigami
    kirigami-addons

    kaccounts-integration
    qtwebengine

    qtshadertools

    phonon

    packagekit-qt

  ])
  ++ (with sonic-DE; [
    sonic-win
    sonic-workspace
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
    description = "The Sonic-DE shell!";
    homepage = "https://github.com/sonic-DE/sonic-desktop-interface";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
})