# The Sonic-DE Flake!

The Sonic Desktop Environment (or just sonic-DE!) is a fork of the KDE that focuses on retaining x11 aspects of code for a hopefully more stable codebase. NixOS support is progressing steadily!

Here are some handy links if you want to get in touch with the team!

[Matrix](https://matrix.to/#/#sonicdesktop:matrix.org)

[Telegram](https://t.me/sonic_de)

## Per-Project Status

Current Version: __6.6.5 / 6.26.0 !__

| Project | Status | Replaces |
| ------------- |:-------------:|:-------------:|
| silver-theme                                   | Working?                                                              | N/A                                                                   |
| sonic-activities                               | Working!                                                              | plasma-activities                                                     |
| sonic-decoration                               | Working!                                                              | kdecoration                                                           |
| sonic-desktop-interface                        | Working!                                                              | plasma-desktop                                                        |
| sonic-frameworks-auth                          | Working!                                                              | kauth                                                                 |
| sonic-frameworks-core-addons                   | Working!                                                              | kcoreaddons                                                           |
| sonic-frameworks-cmake-modules                 | Working!                                                              | extra-cmake-modules                                                   |
| sonic-frameworks-io                            | Working!                                                              | kio                                                                   |
| sonic-interface-libraries                      | Working!                                                              | libplasma                                                             |
| sonic-keybind-daemon                           | Working!                                                              | kglobalacceld                                                         |
| sonic-night-light                              | Working!                                                              | knighttime                                                            |
| sonic-screenlocker                             | Working!                                                              | kscreenlocker                                                         |
| sonic-sysguard-library                         | Working!                                                              | libksysguard                                                          |
| sonic-system-info                              | Working!                                                              | kinfocenter                                                           |
| sonic-win                                      | Working!                                                              | kwin-x11 (or just kwin)                                               |
| sonic-workspace                                | Working!                                                              | plasma-workspace                                                      |
| sonic-workspace-addons                         | Working!                                                              | kdeplasma-addons                                                      |


<!-- 

ALERT!!! I would like to add more parts of the sonic-DE repo to this! feel free to directly edit this readme to include those missing parts in the table below!

| Project | Status | Replaces |
| ------------- |:-------------:|:-------------:|
| silver-sddm                                    |                                                                       | N/A                                                                   |
| silver-theme                                   |                                                                       | N/A                                                                   |
| sonic-activities                               |                                                                       | plasma-activities                                                     |
| sonic-audio-applet-pulse                       |                                                                       | plasma-pa                                                             |
| sonic-decoration                               |                                                                       | kdecoration                                                           |
| sonic-desktop-interface                        |                                                                       | plasma-desktop                                                        |
| sonic-frameworks-auth                          |                                                                       | kauth                                                                 |
| sonic-frameworks-core-addons                   |                                                                       | kcoreaddons                                                           |
| sonic-frameworks-doctools                      |                                                                       | kdoctools                                                             |
| sonic-frameworks-io                            |                                                                       | kio                                                                   |
| sonic-frameworks-io-extras                     |                                                                       | kio-extras                                                            |
| sonic-frameworks-keybind                       |                                                                       | kglobalaccel                                                          |
| sonic-frameworks-quick-ui                      |                                                                       | kirigami                                                              |
| sonic-frameworks-runner                        |                                                                       | krunner                                                               |
| sonic-frameworks-windowsystem                  |                                                                       | kwindowsystem                                                         |
| sonic-interface-libraries                      |                                                                       | libplasma                                                             |
| sonic-keybind-daemon                           |                                                                       | kglobalacceld                                                         |
| sonic-login-manager                            |                                                                       | plasma-login-manager                                                  |
| sonic-mobile-interface                         |                                                                       | plasma-mobile                                                         |
| sonic-network-manager                          |                                                                       | plasma-nm                                                             |
| sonic-night-light                              |                                                                       | knighttime                                                            |
| sonic-screen                                   |                                                                       | kscreen                                                               |
| sonic-screen-library                           |                                                                       | libkscreen                                                            |
| sonic-screenlocker                             |                                                                       | kscreenlocker                                                         |
| sonic-sysguard                                 |                                                                       | libksysguard (this might be a dummy repo)                             |
| sonic-sysguard-library                         |                                                                       | libksysguard                                                          |
| sonic-system-info                              |                                                                       | kinfocenter                                                           |
| sonic-win                                      |                                                                       | kwin-x11 (or just kwin)                                               |
| sonic-workspace                                |                                                                       | plasma-workspace                                                      |
| sonic-workspace-addons                         |                                                                       | kdeplasma-addons                                                      |
| sonic-workspace-wallpapers                     |                                                                       | plasma-workspace-wallpapers                                           |

-->

## Testing and Modifying

By cloning the repo and cd'ing into the new directory, you can run ```nix build .#project-name``` then ```nix log .#project-name``` to evaluate a project. If you find an issue, or have an improvement to suggest, don't hesitate to file a pull request!

## Using this Flake

flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # nixos-26.05 is also supported!
    sonic-de.url = "github:sonicde-nixos/wip-flake/mkSonicDerivation2";
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

All patch files have been taken (and modified if necessary) from nixpkgs. Much of my code is modified from nixpkgs.
