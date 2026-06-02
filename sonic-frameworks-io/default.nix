{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    ./allow-admin-from-store.patch
  ];

  buildDependencies = with pkgs; [
    acl
    attr
    zlib
    libxml2
    libxslt
    krb5

    libx11
    libxcb
    libxkbcommon
  ] 
  ++ (with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qttools
    qt5compat
    qtshadertools

    solid
    kcrash
    kcmutils
    kbookmarks
    kjobwidgets
    ktextwidgets
    kservice
    kdoctools
    kdbusaddons
    kcompletion
    kwallet
    knotifications
    kded
    kwindowsystem
    kxmlgui
    kconfig
    kcoreaddons
    ki18n
    kwidgetsaddons
  ])
  ++ (with sonic-DE; [
    sonic-frameworks-auth
  ]);

  propagatedDependencies = with pkgs; [
    switcheroo-control
    kdePackages.kded
  ];

  extraNativeBuildInputs = with pkgs; [
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Network transparent access to files and data for sonic-DE";
    homepage = "https://github.com/sonic-DE/sonic-frameworks-io";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
}