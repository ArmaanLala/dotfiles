# Media server configuration (*arr stack)
{ config, pkgs, lib, ... }:

{
  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
}
