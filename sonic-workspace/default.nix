{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    (pkgs.replaceVars ./dependency-paths.patch {
      fcMatch = pkgs.lib.getExe' pkgs.fontconfig "fc-match";
      lsof = pkgs.lib.getExe pkgs.lsof;
      qdbus = pkgs.lib.getExe' pkgs.kdePackages.qttools "qdbus";
      xmessage = pkgs.lib.getExe pkgs.xmessage;
      xrdb = pkgs.lib.getExe pkgs.xrdb;
      # @QtBinariesDir@ only appears in the *removed* lines of the diff
      QtBinariesDir = null;
    })

    # stop accidentally duplicating fontconfig configs
    ./fontconfig.patch
  ];

  outputs = [
    "out"
    "dev"
    "devtools"
    "sessions"
  ];

  postInstall = ''
    # Prevent patching this shell file, it only is used by sourcing it from /bin/sh.
    chmod -x $out/libexec/plasma-sourceenv.sh
  '';

  qtWrapperArgs = [ "--inherit-argv0" ];

  postFixup = ''
    mkdir -p $out/nix-support
    echo "${pkgs.lsof} ${pkgs.xmessage} ${pkgs.xrdb}" > $out/nix-support/depends

    moveToOutput share/xsessions $sessions
  '';

  passthru.providedSessions = [
    "plasmax11"
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
    libxcb
    libxcb-cursor
    libxcb-util
    libxcb-image
    #xcb-util
    #xcb-util-keysyms
    #xcb-util-wm
    #xcb-util-image
    #xcb-util-cursor
    #epoxy
    libdrm
    mesa
    #libinput
    udev

    libcanberra
    libdisplay-info
    lcms2

    libxft
    libsm
    libqalculate

    isocodes
    libisocodes
    #libnma
    pipewire

    libXtst

    #libsForQt5.kirigami2
    libsForQt5.polkit-qt

    accountsservice

    lsof
    xmessage
    xrdb
  ] 
  ++ (with pkgs.kdePackages; [
    qtdeclarative
    qtsvg
    #qtwayland
    qt5compat
    qttools
    qtsensors
    qt6.qtlocation
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

    #kauth
    kidletime
    ksvg

    kitemmodels
    kded
    knotifications
    knotifyconfig
    prison
    kstatusnotifieritem

    krunner
    ktexteditor
    plasma5support
    kwayland
    plasma-activities
    plasma-activities-stats
    baloo

    knighttime
    #kdecoration

    kscreenlocker

    #kio
    kfilemetadata

    solid
    networkmanager-qt

    ktextwidgets

    kwallet

    kpeople

    kirigami
    kirigami-addons

    plasma5support

    libkexiv2
    kpipewire

    appstream-qt
    packagekit-qt
    #layer-shell-qt

    phonon
    kscreen
    kholidays

    kquickcharts
    kqtquickcharts

    kunitconversion

    kuserfeedback

    kirigami

    plasma-activities-stats

    qtshadertools

    breeze
  ])
  ++ (with sonic-DE; [
    sonic-win
    sonic-frameworks-io
    sonic-frameworks-auth
    sonic-decoration
    sonic-interface-libraries
    sonic-activities
  ]);

  propagatedDependencies = with pkgs; [
    kdePackages.qtvirtualkeyboard
    kdePackages.kio-extras
    kdePackages.kio-fuse
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
    spirv-tools
  ];

  extraCmakeFlags = with pkgs; [
    "-DGLIBC_LOCALE_GEN=OFF"
    "-DGLIBC_LOCALE_PREGENERATED=ON"
  ];

  hasPythonBindings = false;

  meta = {
    description = "The base of the Sonic Desktop";
    homepage = "https://github.com/sonic-DE/sonic-workspace";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}