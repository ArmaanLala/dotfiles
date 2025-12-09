# Proton host-specific configuration
{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/nfs-media.nix
  ];

  # Host-specific networking
  networking.hostName = "nixos-proton";

  # Jellyfin media server
  services.jellyfin.enable = true;
}
