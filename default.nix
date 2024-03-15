{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  jasmin-src = fetchFromGitHub {
    owner = "jasmin-lang";
    repo = "jasmin";
    rev = "2264ad9de588706c6042abbda1e52188218e4110";
    hash = "sha256-tVjYDrb+46jUACJldAPIZt4+H8fC2VJLo+pOD8aeh1U=";
  };

  jasminc = pkgs.callPackage "${jasmin-src}/default.nix" { inherit pkgs; };
in
stdenv.mkDerivation {
  name = "libjade";
  src = nix-gitignore.gitignoreSource [ ] ./src;

  nativeBuildInputs = [
    jasminc
    gcc
    gnumake
  ];

  buildPhase = ''
    make FAIL_ON_ERROR=1 -C ../src/ -j$(nproc)
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/include
    cp libjade.a $out/lib/
    cp libjade.h $out/include/
  '';
}
