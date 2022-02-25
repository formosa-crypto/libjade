{ pkgs    ? import <nixpkgs> {}
, ocamlP  ? pkgs.ocamlPackages
, provers ? with pkgs; [ z3 cvc4 alt-ergo ]
, ecRev   ? "77aac4b0be22fc83a02d9ea6e32164d893206d94"
, ecSha   ? "rIKrV1+PBTpzOWFwCvHsk3fK+WqhH8uqKB/S35h8P6I="

, bJobs   ? 4
, cJobs   ? 4
}:

with pkgs;
let
  inherit (lib) optionals;

  name  = "easycrypt";
  pname = "${name}-git-" + (builtins.substring 0 7 ecRev);

  minimalOcamlVersion = "4.09";
  maximalOcamlVersion = "4.13.1";

  minimalWhy3Version  = "1.4";
in

if      !lib.versionAtLeast why3.version minimalWhy3Version
then    throw "why3 >= ${minimalWhy3Version} is required"
else if !lib.versionAtLeast ocaml.version minimalOcamlVersion
then    throw  "ocaml >= ${minimalOcamlVersion} is required"
else if !lib.versionAtLeast maximalOcamlVersion ocaml.version
then    throw  "ocaml <= ${maximalOcamlVersion} is required"
else

stdenv.mkDerivation {
  name = name + "-git";
  src = fetchgit {
    url    = "https://github.com/easycrypt/easycrypt";
    rev    = ecRev;
    sha256 = ecSha;
  };

  propagatedBuildInputs = with pkgs; [ why3 ];

  buildInputs =
       (with pkgs; [ git ])
    ++ (with ocamlP; [
          ocaml
          findlib
          batteries
          dune_2
          dune-build-info
          inifiles
          menhir
          menhirLib
          yojson
          zarith
        ]);

  # Playing dirty tricks
  patchPhase = ''
    runHook prePatch
    echo ":100644 100644 15f0b785 00000000 M	dune-project

diff --git a/dune-project b/dune-project
index 15f0b785..c41ae20c 100644
--- a/dune-project
+++ b/dune-project
@@ -3,6 +3,7 @@
 (using dune_site 0.1)

 (name easycrypt)
+(version nix-${builtins.substring 0 8 ecRev})

 (generate_opam_files true)" | patch -p1
    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild
    dune build -p ${name} -j${toString bJobs}
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    dune runtest -p ${name} -j${toString cJobs}
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out -p ${name} -j${toString bJobs}
    runHook postInstall
  '';
}
