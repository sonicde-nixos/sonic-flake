{ pkgs, pname, src, version, Sonic-DE, ... }:

# a mkSonicDerivation function call is not necessary here.
pkgs.stdenv.mkDerivation (finalAttrs: {
  
  inherit pname src version;

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    Sonic-DE.sonic-frameworks-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qttools
    qtsvg

    frameworkintegration
    kcmutils
    kcolorscheme
    kconfig
    kcoreaddons
    kdecoration
    kguiaddons
    ki18n
    kiconthemes
    kirigami
    kwidgetsaddons
    kwindowsystem
  ];

  # Silver is intended for qt6! It's possible to change this if you would like.
  cmakeFlags = [
    (pkgs.lib.cmakeBool "BUILD_QT6" true)
    (pkgs.lib.cmakeBool "BUILD_QT5" false)
  ];

  #passthru.updateScript = gitUpdater {
  #  rev-prefix = "v";
  #};

  meta = {
    description = "Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of Sonic-DE!";
    homepage = "https://github.com/Sonic-DE/silver-theme";
    platforms = pkgs.lib.platforms.linux;
    license = with pkgs.lib.licenses; [
      bsd3
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
      mit
    ];
    mainProgram = "silver-settings";
  };
})