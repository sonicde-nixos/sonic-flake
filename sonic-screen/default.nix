{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  postFixup = ''
    substituteInPlace $out/share/kglobalaccel/org.kde.kscreen.desktop \
      --replace-fail dbus-send ${pkgs.dbus}/bin/dbus-send
  '';

  patches = [
  ];

  buildDependencies = with pkgs; [
  ] 
  ++ (with pkgs.kdePackages; [
    qtsensors
    kconfig
    kdbusaddons
    ki18n
    kcmutils
    ksvg
    kxmlgui
    kcrash
    libkscreen
    kpackage
    kimageformats
    kitemmodels
    plasma5support
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
    sonic-interface-libraries
  ]);

  propagatedDependencies = with pkgs; [
    kdePackages.kimageformats
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "Screen management software for Sonic-DE!";
    homepage = "https://github.com/Sonic-DE/sonic-screen";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "kscreen-console";
  };
}