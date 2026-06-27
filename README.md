# The Sonic-DE Flake!

The Sonic Desktop Environment (or just sonic-DE!) is a fork of the KDE that focuses on retaining x11 aspects of code for a hopefully more stable codebase.

Here are some handy links if you want to get in touch with the team!

The Sonic Desktop Environment will build on your machine. Please be patient!

[Matrix](https://matrix.to/#/#sonicdesktop:matrix.org)

[Telegram](https://t.me/sonic_de)

## Per-Project Status

Current Version: __6.7.1 / 6.27.0 !__

| Project | Status | Replaces |
| ------------- |:-------------:|:-------------:|
| silver-theme                                   | Working?                                                              | N/A                                                                   |
| sonic-audio-applet-pulse                       | Working!                                                              | plasma-pa                                                             |
| sonic-activities                               | Working!                                                              | plasma-activities                                                     |
| sonic-decoration                               | Working!                                                              | kdecoration                                                           |
| sonic-desktop-interface                        | Working!                                                              | plasma-desktop                                                        |
| sonic-frameworks-auth                          | Working!                                                              | kauth                                                                 |
| sonic-frameworks-core-addons                   | Working!                                                              | kcoreaddons                                                           |
| sonic-frameworks-cmake-modules                 | Working!                                                              | extra-cmake-modules                                                   |
| sonic-frameworks-gui-addons                    | Working!                                                              | kguiaddons                                                            |
| sonic-frameworks-io                            | Working!                                                              | kio                                                                   |
| sonic-frameworks-keybind                       | Working!                                                              | kglobalaccel                                                          |
| sonic-frameworks-runner                        | Working!                                                              | krunner                                                               |
| sonic-frameworks-windowsystem                  | Working!                                                              | kwindowsystem                                                         |
| sonic-interface-libraries                      | Working!                                                              | libplasma                                                             |
| sonic-keybind-daemon                           | Working!                                                              | kglobalacceld                                                         |
| sonic-network-manager                          | Working!                                                              | plasma-nm                                                             |
| sonic-night-light                              | Working!                                                              | knighttime                                                            |
| sonic-screen                                   | Working!                                                              | kscreen                                                               |
| sonic-screen-library                           | Working!                                                              | libkscreen                                                            |
| sonic-screenlocker                             | Working!                                                              | kscreenlocker                                                         |
| sonic-sysguard-library                         | Working!                                                              | libksysguard                                                          |
| sonic-system-info                              | Working!                                                              | kinfocenter                                                           |
| sonic-win                                      | Working!                                                              | kwin-x11 (or just kwin)                                               |
| sonic-workspace                                | Working!                                                              | plasma-workspace                                                      |
| sonic-workspace-addons                         | Working!                                                              | kdeplasma-addons                                                      |
| sonic-workspace-wallpapers                     | Working!                                                              | plasma-workspace-wallpapers                                           |

## Testing and Modifying

By cloning the repo and cd'ing into the new directory, you can run ```nix build .#project-name``` then ```nix log .#project-name``` to evaluate a project. If you find an issue, or have an improvement to suggest, don't hesitate to file a pull request!

## Using this Flake

flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # 26.05 is not supported. However, the 6.6.5 release does support 26.05! 
    sonic-de.url = "github:sonicde-nixos/sonic-flake/6.7.1";
    sonic-de.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, sonic-de ... }@inputs: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs sonic-de; };
      modules = [
        # this module will allow you to just set an option to enable Sonic-DE!
        "${sonic-de}/sonic-de.nix"

        ./configuration.nix

      ];
    };
  };
}

```

configuration.nix

```nix

{ config, pkgs, sonic-de, ... }:

{
  services.desktopManager.sonic-de.enable = true; # if you used the module we provide!

  environment.systemPackages = with pkgs; [
    # normal packages
    git
    htop
    wget
    # ...
  ] ++ (with sonic-de.packages.${pkgs.system}; [ # to test individual packages
    # sonic packages
    sonic-win
    sonic-workspace
    sonic-desktop-interface
    # ...
  ]);
}

```

All patch files have been taken (and modified if necessary) from nixpkgs. Parts of my code are modified from equivalent versions in nixpkgs.
