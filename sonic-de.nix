
# taken and modified from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix

{
  config,
  lib,
  pkgs,
  utils,
  sonic-de,
  ...
}:
let
  cfg = config.services.desktopManager.sonic-de;

  inherit (pkgs) kdePackages;
  inherit (lib)
    literalExpression
    mkDefault
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  activationScript = ''
    # will be rebuilt automatically
    rm -fv "''${XDG_CACHE_HOME:-$HOME/.cache}/ksycoca"*
  '';

  Sonic-DE = sonic-de.packages.${pkgs.system};
in
{
  options = {
    services.desktopManager.sonic-de = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Plasma 6 (KDE 6) desktop environment.";
      };

      #enableQt5Integration = mkOption {
      #  type = types.bool;
      #  default = true;
      #  description = "Enable Qt 5 integration (theming, etc). Disable for a pure Qt 6 system.";
      #};

      notoPackage = mkPackageOption pkgs "Noto fonts - used for UI by default" {
        default = [ "noto-fonts" ];
        example = "noto-fonts-lgc-plus";
      };
    };

    environment.sonic-de.excludePackages = mkOption {
      description = "List of default packages to exclude from the configuration";
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.kdePackages.elisa ]";
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "sonic-de" "enable" ]
      [ "services" "desktopManager" "sonic-de" "enable" ]
    )
    /*(lib.mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "sonic-de" "enableQt5Integration" ]
      [ "services" "desktopManager" "sonic-de" "enableQt5Integration" ]
    )*/
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "sonic-de" "notoPackage" ]
      [ "services" "desktopManager" "sonic-de" "notoPackage" ]
    )
  ];

  config = mkIf cfg.enable {
    qt.enable = true;
    #programs.xwayland.enable = true;
    environment.systemPackages =
      with kdePackages;
      let
        requiredPackages = [
          #qtwayland # Hack? To make everything run on Wayland
          qtsvg # Needed to render SVG icons

          # Frameworks with globally loadable bits
          frameworkintegration # provides Qt plugin
          Sonic-DE.sonic-frameworks-auth #kauth # provides helper service
          Sonic-DE.sonic-frameworks-core-addons #kcoreaddons # provides extra mime type info
          kded # provides helper service
          kfilemetadata # provides Qt plugins
          Sonic-DE.sonic-frameworks-gui-addons #kguiaddons # provides geo URL handlers
          kiconthemes # provides Qt plugins
          kimageformats # provides Qt plugins
          qtimageformats # provides optional image formats such as .webp and .avif
          Sonic-DE.sonic-frameworks-io #kio # provides helper service + a bunch of other stuff
          kio-admin # managing files as admin
          kio-extras # stuff for MTP, AFC, etc
          kio-fuse # fuse interface for KIO
          Sonic-DE.sonic-night-light #knighttime # night mode switching daemon
          kpackage # provides kpackagetool tool
          kservice # provides kbuildsycoca6 tool
          kunifiedpush # provides a background service and a KCM
          kwallet # provides helper service
          kwallet-pam # provides helper service
          kwalletmanager # provides KCMs and stuff
          plasma-activities # provides plasma-activities-cli tool
          solid # provides solid-hardware6 tool
          phonon-vlc # provides Phonon plugin

          # Core Plasma parts
          Sonic-DE.sonic-win #kwin-x11
          Sonic-DE.sonic-screen#kscreen
          Sonic-DE.sonic-screen-library#libkscreen
          Sonic-DE.sonic-screenlocker #kscreenlocker
          kactivitymanagerd
          kde-cli-tools
          Sonic-DE.sonic-keybind-daemon #kglobalacceld # keyboard shortcut daemon
          kwrited # wall message proxy, not to be confused with kwrite
          baloo # system indexer
          milou # search engine atop baloo
          kdegraphics-thumbnailers # pdf etc thumbnailer
          polkit-kde-agent-1 # polkit auth ui
          Sonic-DE.sonic-desktop-interface #plasma-desktop
          Sonic-DE.sonic-workspace #plasma-workspace
          drkonqi # crash handler
          kde-inotify-survey # warns the user on low inotifywatch limits

          # Application integration
          Sonic-DE.sonic-interface-libraries #libplasma # provides Kirigami platform theme
          plasma-integration # provides Qt platform theme
          kde-gtk-config # syncs KDE settings to GTK

          # Artwork + themes
          breeze
          breeze-icons
          breeze-gtk
          ocean-sound-theme
          pkgs.hicolor-icon-theme # fallback icons
          qqc2-breeze-style
          qqc2-desktop-style

          # misc Plasma extras
          Sonic-DE.sonic-workspace-addons #kdeplasma-addons
          pkgs.xdg-user-dirs # recommended upstream

          # Plasma utilities
          kmenuedit
          Sonic-DE.sonic-system-info #kinfocenter
          plasma-systemmonitor
          ksystemstats
          Sonic-DE.sonic-sysguard-library #libksysguard
          systemsettings
          kcmutils
        ];
        optionalPackages = [

          Sonic-DE.silver-theme

          aurorae
          plasma-browser-integration
          Sonic-DE.sonic-workspace-wallpapers #plasma-workspace-wallpapers
          konsole
          #kwin-x11
          (lib.getBin qttools) # Expose qdbus in PATH
          ark
          elisa
          gwenview
          okular
          kate
          ktexteditor # provides elevated actions for kate
          khelpcenter
          dolphin
          baloo-widgets # baloo information in Dolphin
          dolphin-plugins
          spectacle
          ffmpegthumbs
          krdp
          kconfig # required for xdg-terminal from xdg-utils
          qtbase # for qtpaths which is required for xdg-mime from xdg-utils
        ]
        ++ lib.optional config.networking.networkmanager.enable qrca
        ++ lib.optionals config.hardware.sensor.iio.enable [
          # This is required for autorotation in Plasma 6
          qtsensors
        ]
        #++ lib.optionals (config.services.flatpak.enable || config.services.fwupd.enable) [
        #  # Since PackageKit Nix support is not there yet,
        #  # only install discover if flatpak or fwupd is enabled.
        #  discover
        #];
        ;
      in
      requiredPackages
      ++ utils.removePackagesByName optionalPackages config.environment.sonic-de.excludePackages
      /*++ lib.optionals config.services.desktopManager.sonic-de.enableQt5Integration [
        breeze.qt5
        plasma-integration.qt5
        kwayland-integration
        (
          # Only symlink the KIO plugins, so we don't accidentally pull any services
          # like KCMs or kcookiejar
          let
            kioPluginPath = "${pkgs.plasma5Packages.qtbase.qtPluginPrefix}/kf5/kio";
            inherit (pkgs.plasma5Packages) kio;
          in
          pkgs.runCommand "kio5-plugins-only" { } ''
            mkdir -p $out/${kioPluginPath}
            ln -s ${kio}/${kioPluginPath}/* $out/${kioPluginPath}
          ''
        )
        kio-extras-kf5
      ]*/
      # Optional and hardware support features
      ++ lib.optionals config.hardware.bluetooth.enable [
        bluedevil
        bluez-qt
        pkgs.openobex
        pkgs.obexftp
      ]
      ++ lib.optional config.networking.networkmanager.enable Sonic-DE.sonic-network-manager #plasma-nm
      ++ lib.optional config.services.pulseaudio.enable Sonic-DE.sonic-audio-applet-pulse #plasma-pa
      ++ lib.optional config.services.pipewire.pulse.enable Sonic-DE.sonic-audio-applet-pulse #plasma-pa
      ++ lib.optional config.powerManagement.enable powerdevil
      ++ lib.optional config.services.printing.enable print-manager
      ++ lib.optional config.hardware.sane.enable skanpage
      ++ lib.optional config.services.colord.enable colord-kde
      ++ lib.optional config.services.hardware.bolt.enable plasma-thunderbolt
      ++ lib.optional config.services.samba.enable kdenetwork-filesharing
      ++ lib.optional config.services.xserver.wacom.enable wacomtablet
      #++ lib.optional config.services.flatpak.enable flatpak-kcm;
      ;
    
    environment.pathsToLink = [
      # FIXME: modules should link subdirs of `/share` rather than relying on this
      "/share"
      "/libexec" # for drkonqi
    ];

    environment.etc."X11/xkb".source = config.services.xserver.xkb.dir;

    # Add ~/.config/kdedefaults to XDG_CONFIG_DIRS for shells, since Plasma sets that.
    # FIXME: maybe we should append to XDG_CONFIG_DIRS in /etc/set-environment instead?
    environment.sessionVariables.XDG_CONFIG_DIRS = [ "$HOME/.config/kdedefaults" ];

    # Needed for things that depend on other store.kde.org packages to install correctly,
    # notably Plasma look-and-feel packages (a.k.a. Global Themes)
    #
    # FIXME: this is annoyingly impure and should really be fixed at source level somehow,
    # but kpackage is a library so we can't just wrap the one thing invoking it and be done.
    # This also means things won't work for people not on Plasma, but at least this way it
    # works for SOME people.
    environment.sessionVariables.KPACKAGE_DEP_RESOLVERS_PATH = "${kdePackages.frameworkintegration.out}/libexec/kf6/kpackagehandlers";

    # Enable GTK applications to load SVG icons
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    fonts.packages = [
      cfg.notoPackage
      pkgs.hack-font
    ];
    fonts.fontconfig.defaultFonts = {
      monospace = [
        "Hack"
        "Noto Sans Mono"
      ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };

    programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-qt;
    programs.kde-pim.enable = mkDefault true;
    programs.ssh.askPassword = mkDefault "${kdePackages.ksshaskpass.out}/bin/ksshaskpass";

    # Enable helpful DBus services.
    services.accounts-daemon.enable = true;
    # when changing an account picture the accounts-daemon reads a temporary file containing the image which systemsettings5 may place under /tmp
    systemd.services.accounts-daemon.serviceConfig.PrivateTmp = false;

    services.power-profiles-daemon.enable = mkDefault true;
    services.system-config-printer.enable = mkIf config.services.printing.enable (mkDefault true);
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.libinput.enable = mkDefault true;
    services.geoclue2.enable = mkDefault true;
    services.fwupd.enable = mkDefault true;

    # Extra UDEV rules used by Solid
    services.udev.packages = [
      # libmtp has "bin", "dev", "out" outputs. UDEV rules file is in "out".
      pkgs.libmtp.out
      pkgs.media-player-info
    ];

    # Set up Dr. Konqi as crash handler
    systemd.packages = [ kdePackages.drkonqi ];
    systemd.services."drkonqi-coredump-processor@".wantedBy = [ "systemd-coredump@.service" ];

    xdg.icons.enable = true;
    xdg.icons.fallbackCursorThemes = mkDefault [ "breeze_cursors" ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      kdePackages.kwallet
      kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
    ];
    #xdg.portal.configPackages = mkDefault [ kdePackages.plasma-workspace ];
    xdg.portal.configPackages = mkDefault [ Sonic-DE.sonic-workspace ];
    services.pipewire.enable = mkDefault true;

    # Enable screen reader by default
    services.orca.enable = mkDefault true;

    services.displayManager = {
      #sessionPackages = [ kdePackages.plasma-workspace.sessions ];
      sessionPackages = [ Sonic-DE.sonic-workspace.sessions ];
      defaultSession = mkDefault "plasmax11";
    };
    services.displayManager.sddm = {
      package = kdePackages.sddm;
      theme = mkDefault "breeze";
      wayland = mkDefault {
        enable = false;
        #compositor = "kwin";
      };
      extraPackages = with kdePackages; [
        breeze-icons
        kirigami
        #Sonic-DE.sonic-interface-libraries #libplasma
        libplasma
        plasma5support
        qtsvg
        qtvirtualkeyboard
      ];
    };

    security.pam.services = {
      login.kwallet = {
        enable = true;
        package = kdePackages.kwallet-pam;
      };
      kde = {
        allowNullPassword = true;
        kwallet = {
          enable = true;
          package = kdePackages.kwallet-pam;
        };
        # "kde" must not have fingerprint authentication otherwise it can block password login.
        # See https://github.com/NixOS/nixpkgs/issues/239770 and https://invent.kde.org/plasma/kscreenlocker/-/merge_requests/163.
        fprintAuth = false;
        p11Auth = false;
      };
      kde-fingerprint = lib.mkIf config.services.fprintd.enable {
        fprintAuth = true;
        p11Auth = false;
      };
      kde-smartcard = lib.mkIf config.security.pam.p11.enable {
        p11Auth = true;
        fprintAuth = false;
      };
    };

    security.wrappers = {
      #kwin_wayland = {
      #  owner = "root";
      #  group = "root";
      #  capabilities = "cap_sys_nice+ep";
      #  source = "${lib.getBin pkgs.kdePackages.kwin}/bin/kwin_wayland";
      #};

      kwin_x11 = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice+ep";
        #source = "${lib.getBin pkgs.kdePackages.kwin-x11}/bin/kwin_x11";
        source = "${lib.getBin Sonic-DE.sonic-win}/bin/kwin_x11";
      };

      ksystemstats_intel_helper = {
        owner = "root";
        group = "root";
        capabilities = "cap_perfmon+ep";
        source = "${pkgs.kdePackages.ksystemstats}/libexec/ksystemstats_intel_helper";
      };

      ksgrd_network_helper = {
        owner = "root";
        group = "root";
        capabilities = "cap_net_raw+ep";
        source = "${pkgs.kdePackages.libksysguard}/libexec/ksysguard/ksgrd_network_helper";
      };
    };

    # Upstream recommends allowing set-timezone and set-ntp so that the KCM and
    # the automatic timezone logic work without user interruption.
    # However, on NixOS NTP cannot be overwritten via dbus, and timezone
    # can only be set if `time.timeZone` is set to `null`. So, we only allow
    # set-timezone, and we only allow it when the timezone can actually be set.
    security.polkit.extraConfig = lib.mkIf (config.time.timeZone != null) ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.timedate1.set-timezone" && subject.active) {
          return polkit.Result.YES;
        }
      });
    '';

    programs.dconf.enable = true;

    programs.firefox.nativeMessagingHosts.packages = [ kdePackages.plasma-browser-integration ];

    programs.chromium = {
      enablePlasmaBrowserIntegration = true;
      plasmaBrowserIntegrationPackage = pkgs.kdePackages.plasma-browser-integration;
    };

    programs.kdeconnect.package = kdePackages.kdeconnect-kde;
    programs.partition-manager.package = kdePackages.partitionmanager;

    # FIXME: ugly hack. See #292632 for details.
    system.userActivationScripts.rebuildSycoca = activationScript;
    systemd.user.services.nixos-rebuild-sycoca = {
      description = "Rebuild KDE system configuration cache";
      wantedBy = [ "graphical-session-pre.target" ];
      serviceConfig.Type = "oneshot";
      script = activationScript;
    };
  };
}
