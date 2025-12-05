{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.atlas = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
      };
    };
}
