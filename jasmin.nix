{ pkgs ? import <nixpkgs> {}
, jasminRev ? "1876e97717691e18d6be78c3bc1952a7f319786e"
, jasminSha ? "GcbrMGdemenJcY9i/i0Dal2cA8/w0lN67AtM/NR85ho="
}:

with pkgs;

let coqPackages = coqPackages_8_14; in

let coqword = callPackage ./coqword.nix { inherit coqPackages; }; in

let inherit (coqPackages.coq) ocamlPackages; in

if !lib.versionAtLeast ocamlPackages.ocaml.version "4.08"
then throw "Jasmin requires OCaml ≥ 4.08"
else

stdenv.mkDerivation {
  name = "jasmin-git";

  src = fetchgit {
    url    = "https://github.com/jasmin-lang/jasmin";
    rev    = jasminRev;
    sha256 = jasminSha;
  };

  buildInputs = [ ncurses ]
    ++ [ coqPackages.coq coqword ]
    ++ [ ocamlPackages.apron.out ] ++ (with python3Packages; [ python pyyaml ])
    ++ [ mpfr ppl ] ++ (with ocamlPackages; [
         ocaml findlib ocamlbuild
         (batteries.overrideAttrs (o: { doCheck = false; }))
         menhir (ocamlPackages.menhirLib or null) zarith camlidl apron yojson ])
    ;

  preBuild = "echo $out";

  installPhase = ''
    runHook preInstall
    export PREFIX=$out
    export COQLIBINSTALL=$PREFIX/lib/coq/user-contrib
    export COQDOCINSTALL=$PREFIX/doc/coq/user-contrib
    make install
    runHook postInstall
  '';
}
