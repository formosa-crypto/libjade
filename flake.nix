{
  description = "Libjade";

  inputs = {
    nixpkgs.url = "nixpkgs/release-24.05";

    easycrypt.url = "github:EasyCrypt/easycrypt/4201fddc14b81d2a69a33f034c9c7db4dfd58d0e";
    jasmin = {
      url = "github:jasmin-lang/jasmin/e4640e7dcdb01d1ba63617a5d78456e1209d699c";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, easycrypt, jasmin, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { pkgs, system, self', ... }:
        let
          ec = easycrypt.packages.${system};
          jasminc = pkgs.callPackage "${jasmin}/default.nix" { inherit pkgs; };
        in
        {
          packages.default = pkgs.callPackage ./default.nix { inherit pkgs jasminc; };

          devShells.default = pkgs.mkShell {
            name = "libjade";
            src = self'.packages.default.src;

            packages = [
              ec.with_provers
              pkgs.why3
            ];

            ECARGS = "-I Jasmin:${jasmin}/eclib";

            shellHook = ''
              easycrypt why3config
            '';
          };
        };
    };
}
