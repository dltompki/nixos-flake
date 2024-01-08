{
  description = "dltompki's NixOS system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      maple-nix = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
