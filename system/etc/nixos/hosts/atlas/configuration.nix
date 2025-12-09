# Atlas host-specific configuration
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/common.nix
    ../../modules/vm-hardware.nix
    ../../modules/media-server.nix
    ../../modules/nfs-media.nix
  ];

  # Host-specific networking
  networking.hostName = "atlas";
}
