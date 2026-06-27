{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    ./fix-paths.patch
  ];

  buildDependencies = with pkgs.kdePackages; [
    qtdeclarative
    qttools
    qt5compat

    polkit-qt-1
  ]
  ++ (with Sonic-DE; [
    sonic-frameworks-cmake-modules
    sonic-frameworks-core-addons
    sonic-frameworks-windowsystem
  ]);

  propagatedDependencies = with pkgs; [
  ];

  extraNativeBuildInputs = with pkgs; [
    kdePackages.qttools
    shared-mime-info
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = true;

  meta = {
    description = "Secure and integrated way to execute actions as privileged user in Sonic-DE";
    homepage = "https://github.com/Sonic-DE/sonic-frameworks-auth";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
}