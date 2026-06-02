{ mkSonicDerivation, pkgs, pname, src, version, sonic-DE, ... }:

mkSonicDerivation {

  inherit pname src version;

  patches = [
    ./fix-paths.patch
  ];

  buildDependencies = with pkgs.kdePackages; [
    qtdeclarative
    qttools
    qt5compat

    kcoreaddons
    kwindowsystem
    polkit-qt-1
  ]
  ++ (with sonic-DE; [
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
    homepage = "https://github.com/sonic-DE/sonic-frameworks-auth";
    license = pkgs.lib.licenses.gpl2Plus;
    platform = pkgs.lib.platforms.linux;
  };
}