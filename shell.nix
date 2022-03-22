{ pkgs    ? import <nixpkgs> { }
}:

with pkgs;

let
  easycrypt = callPackage (import ./scripts/nix/easycrypt.nix) { };
  jasmin    = callPackage (import ./scripts/nix/jasmin.nix) { };

  pythonEnv = python3.withPackages (p: with p; [ pyyaml ]);

  provers   = [ z3 alt-ergo cvc4 ];
in

pkgs.mkShell {
  packages = [ easycrypt jasmin pythonEnv ] ++ provers;

  shellHook = ''
    PYTHONPATH=${pythonEnv}/${pythonEnv.sitePackages}
    export ME=$(mktemp -d)
    export XDG_CONFIG_HOME=$ME/.config
    mkdir -p $ME/.config/easycrypt
    echo "Setting up Jasmin import from ${jasmin.out}/lib/jasmin/easycrypt/"
    printf "[general]\nidirs = Jasmin:${jasmin.out}/lib/jasmin/easycrypt" > $ME/.config/easycrypt/easycrypt.conf
    easycrypt why3config
  '';
}
