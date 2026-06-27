{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    (pkgs.replaceVars ./hardcode-paths.patch {
      openvpn = pkgs.lib.getExe pkgs.openvpn;
      ipsec = pkgs.lib.getExe' pkgs.strongswan "ipsec";
    })
  ];

  buildDependencies = with pkgs; [
    mobile-broadband-provider-info
    openconnect
    libsysprof-capture
    qt6Packages.qtkeychain
  ] 
  ++ (with pkgs.kdePackages; [
    qttools
    qtwebengine
    kcompletion
    kdbusaddons
    kjobwidgets
    networkmanager-qt
    knotifications
    kservice
    solid
    kwallet
    kcmutils
    ksvg
    modemmanager-qt
    kpackage
    qcoro
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
    sonic-frameworks-io
    sonic-frameworks-windowsystem
    sonic-interface-libraries
  ]);

  propagatedDependencies = with pkgs; [
    kdePackages.kirigami-addons
    kdePackages.prison # who comes up with these names?
    kdePackages.kqtquickcharts # see, that's reasonable.
    kdePackages.kquickcharts # they made it stupid again
  ];

  # use sonic-DE because we name things reasonably :P

  extraNativeBuildInputs = with pkgs; [
    pkg-config
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Applet to manage your internet connection on Sonic-DE!";
    homepage = "https://github.com/Sonic-DE/sonic-network-manager";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}