{ mkSonicDerivation, pkgs, pname, src, version, Sonic-DE, ... }:

mkSonicDerivation (
let 
  lib = pkgs.lib;
  tools = {
    aha = lib.getExe pkgs.aha;
    clinfo = lib.getExe pkgs.clinfo;
    di_edid_decode = lib.getExe pkgs.libdisplay-info;
    dmidecode = lib.getExe' pkgs.dmidecode "dmidecode";
    eglinfo = lib.getExe' pkgs.mesa-demos "eglinfo";
    glxinfo = lib.getExe' pkgs.mesa-demos "glxinfo";
    ip = lib.getExe' pkgs.iproute2 "ip";
    lsblk = lib.getExe' pkgs.util-linux "lsblk";
    lspci = lib.getExe' pkgs.pciutils "lspci";
    lscpu = lib.getExe' pkgs.util-linux "lscpu";
    pactl = lib.getExe' pkgs.pulseaudio "pactl";
    qdbus = lib.getExe' pkgs.kdePackages.qttools "qdbus";
    sensors = lib.getExe' pkgs.lm_sensors "sensors";
    vulkaninfo = lib.getExe' pkgs.vulkan-tools "vulkaninfo";
    xdpyinfo = lib.getExe pkgs.xdpyinfo;
  };
in 
{

  inherit pname src version;

  preFixup = ''
    # Fix dangling kinfocenter symlink (points to systemsettings from KDE)
    # taken from https://github.com/NixOS/nixpkgs/blob/master/pkgs/kde/plasma/kinfocenter/default.nix
    ln -sf ${pkgs.kdePackages.systemsettings}/bin/systemsettings $out/bin/kinfocenter
    # this line might be a bad idea, because I don't know how it will depend on whether or not
    # systemsettings is installed, and other little details
  '';

  postPatch = ''
    substituteInPlace kcms/firmware_security/fwupdmgr.sh \
      --replace-fail " aha " " ${lib.getExe pkgs.aha} "
  '';

  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lib.concatStringsSep ":" (lib.attrValues tools)}" > $out/nix-support/depends
  '';

  qtWrapperArgs = [ "--inherit-argv0" ];

  patches = [
    # fwupdmgr is provided through NixOS' module
    # this one has been edited to remove wayland references
    (pkgs.replaceVars ./0001-tool-paths.patch (
      {
        # @QtBinariesDir@ only appears in the *removed* lines of the diff
        QtBinariesDir = null;
      }
      // tools
    ))
  ];

  buildDependencies = with pkgs; [
    libglvnd
    mesa
    libdrm
    pciutils
    libusb1
    udev
    vulkan-headers
    vulkan-tools
    fwupd
    aha
    clinfo

    xdpyinfo
    mesa-demos
    dmidecode
  ] 
  ++ (with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qttools
    qt5compat

    ki18n
    kcompletion
    kconfig
    kconfigwidgets
    kdbusaddons
    kdeclarative
    kiconthemes
    kcmutils
    kservice
    solid
    kwidgetsaddons
    kxmlgui
  ])
  ++ (with Sonic-DE; [
    sonic-frameworks-io
    sonic-frameworks-core-addons
    sonic-frameworks-auth
  ]);

  propagatedDependencies = with pkgs; [
    vulkan-tools
    libuuid
    xdpyinfo
    mesa-demos
    pciutils
    fwupd
    clinfo
    iproute2
    aha
    pipewire
    dmidecode
    libdisplay-info
    lm_sensors
  ];

  extraNativeBuildInputs = with pkgs; [
    pkg-config
  ];

  extraCmakeFlags = with pkgs; [
  ];

  hasPythonBindings = false;

  meta = {
    description = "A handy tool to view information about your system on Sonic-DE!";
    homepage = "https://github.com/Sonic-DE/sonic-system-info";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
})