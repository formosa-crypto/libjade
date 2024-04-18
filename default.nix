{ pkgs ? import <nixpkgs> { }
, jasminc
}:
with pkgs;
stdenv.mkDerivation {
  name = "libjade";
  src = ./src;

  nativeBuildInputs = with pkgs; [
    jasminc
    clang
    gnumake
  ];

  buildPhase = ''
    make FAIL_ON_ERROR=1 -j$(nproc)
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/include
    cp libjade.a $out/lib/
    cp libjade.h $out/include/
  '';

}
