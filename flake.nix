{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    npiperelay = {
      url = "path:./npiperelay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, npiperelay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; overlays = [ npiperelay.overlay ]; };
      up = pkgs.writeScriptBin "up" ''
        #!${pkgs.stdenv.shell}
        nix build .#homeManagerConfigurations.linux.activationPackage && ./result/activate
      '';
    in
      {
        homeManagerConfigurations = {
          linux = home-manager.lib.homeManagerConfiguration {
            configuration = ./home.nix;
            system = system;
            homeDirectory = "/home/plumps";
            username = "plumps";
            pkgs = pkgs;
          };
        };
        devShell.${system} = pkgs.mkShell {
          description = "hm-shell";
          nativeBuildInputs = with pkgs; [ bashInteractive up nixfmt ];
	};
      };
}
    
