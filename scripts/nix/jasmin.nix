{ pkgs ? import <nixpkgs> {}
, jasminRev ? "d33e055dbb596c31e85e93b3b7da05d7bc341ace"
, jasminSha ? "sha256:QD8mbYEBge4cEQEVRsB7nJWYO4cyEPuOdeffmwp/MFE="
}:

with pkgs;

let coqPackages = coqPackages_8_14; in

let coqword = callPackage ./coqword.nix { inherit coqPackages; }; in

let inherit (coqPackages.coq) ocamlPackages; in

if !lib.versionAtLeast ocamlPackages.ocaml.version "4.08"
then throw "Jasmin requires OCaml ≥ 4.08"
else

stdenv.mkDerivation {
  pname   = "jasmin";
  version = "git-" + builtins.substring 0 8 jasminRev;

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
