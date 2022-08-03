with import <nixpkgs> {};

mkShell {
  buildInputs = [
  (python3.withPackages (ps: [ ps.pytest ps.pyyaml ps.py-cpuinfo ]))
  ];
}
