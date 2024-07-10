{
  description = "Libjade";

  inputs = {
    nixpkgs.url = "nixpkgs/release-23.11";
    easycrypt.url = "github:EasyCrypt/easycrypt/4201fddc14b81d2a69a33f034c9c7db4dfd58d0e";
    jasmin = {
      url = "github:jasmin-lang/jasmin/e4640e7dcdb01d1ba63617a5d78456e1209d699c";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, easycrypt, jasmin, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      jasminc = pkgs.callPackage "${jasmin}/default.nix" { inherit pkgs; };
      ec = easycrypt.packages.${system}.default;
    in
    {
      packages.${system}.default = pkgs.callPackage ./default.nix { inherit pkgs jasminc; };

      devShells.${system}.default = pkgs.mkShell {
        name = "libjade";
        src = self.packages.${system}.default.src;

        packages = self.packages.${system}.default.nativeBuildInputs ++
          [
            ec
            pkgs.valgrind
            pkgs.cvc4
            pkgs.cvc5
            pkgs.z3
          ];

        EASYCRYPT = "${ec}/bin/easycrypt";
        ECARGS = "-I Jasmin:${jasmin}/eclib";

        shellHook = ''
          easycrypt why3config
        '';
      };
    };
}
