{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    ./config-mtime.patch
    ./config-path.patch
    (pkgs.replaceVars ./xserver-path.patch {
      xserverPath = pkgs.lib.getExe' pkgs.xorg-server "Xorg";
    })
  ];

  postPatch = ''
    substituteInPlace src/frontend/startkde/soniclogin-kwin_x11.service.in \
      --replace '@CMAKE_INSTALL_FULL_BINDIR@' '${Sonic-DE.sonic-win}/bin'
  '';

  buildDependencies = with pkgs; [
    pam
    utmps
    libcap
  ] 
  ++ (with pkgs.kdePackages; [
    kconfig
    kpackage
    ki18n
    kdbusaddons
    kcmutils
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
    sonic-frameworks-windowsystem
    sonic-frameworks-auth
    sonic-frameworks-io
    sonic-interface-libraries
    sonic-workspace
    sonic-screen
    sonic-screen-library
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
    kdePackages.qttools
  ];

  extraCmakeFlags = with pkgs; [
    "-DUID_MIN=1000"
    "-DUID_MAX=29999"
    "-DINSTALL_PAM_CONFIGURATION=OFF"
  ];

  hasPythonBindings = false;

  meta = {
    description = "EXPIRIMENTAL login manager for Sonic-DE.";
    homepage = "https://github.com/Sonic-DE/sonic-login-manager";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}