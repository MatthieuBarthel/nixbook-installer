{
  description = "Custom NixOS Installer ISO with Calamares";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          patches = [ ./calamares-nixos-extensions.patch ];
        };

        nixosConfiguration = nixpkgs.lib.nixosSystem {
          inherit pkgs system;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"

            {
              nix.extraOptions = "experimental-features = nix-command flakes";
              image.fileName = "nixos-custom-installer.iso";
              system.stateVersion = "25.11";
            }
          ];
        };
      in {
        packages.install-iso = nixosConfiguration.config.system.build.isoImage;
      });
}
