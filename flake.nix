{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem [ utils.lib.system.x86_64-linux ] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      stdenv = pkgs.stdenv;
      lib = pkgs.lib;

      choregrapheSrc = pkgs.fetchurl {
        url = "https://community-static.aldebaran.com/resources/2.8.8/choregraphe-2.8.8-ubuntu2204-standalone.tar.gz";
        sha256 = "sha256-DjAnMDC+JOVV9IrAQln74Jsk6hAuWzKm5qH/EoOrBPk=";
      };

      choregrapheApp = stdenv.mkDerivation {
        name = "choregraphe";
        src = choregrapheSrc;
        doCheck = false;
        
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          mv * $out
          runHook postInstall
        '';
      };
    in rec {
      packages = {
        choregraphe = choregrapheApp;
      };
      apps.default = {
        type = "app";
        program = "${packages.choregraphe}/choregraphe";
      };
    });
}
