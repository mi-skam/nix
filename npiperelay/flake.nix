{
  description = "npiperelay (windows amd64 binary)";

  outputs = { self, nixpkgs }:

    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
      {
        packages.x86_64-linux.npiperelay = pkgs.stdenv.mkDerivation rec {
          pname = "npiperelay";
          version = "0.1.0";
          src = pkgs.fetchurl {
            url = "https://github.com/jstarks/npiperelay/releases/download/v${version}/npiperelay_windows_amd64.zip";
            sha256 = "1xp59iv1wp92yhxzqrxcd7kdmcyfbn0lvmd3m43kbh0pzlgzd7kb";
          };
          nativeBuildInputs = with pkgs; [ unzip ];
          phases = [ "unpackPhase" "installPhase" ];

          unpackPhase = ''
            unzip $src
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp npiperelay.exe $out/bin/
          '';
        };

        defaultPackage.x86_64-linux = self.packages.x86_64-linux.npiperelay;

        overlay = final: prev: {
          npiperelay = self.packages.x86_64-linux.npiperelay;
        };

      };

}
