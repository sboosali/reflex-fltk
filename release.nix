{ compiler ? null # [e.g.] --attrstr compiler ghc842
}:

let

pkgs =
 import ./nix/nixpkgs.nix { };

# hspkgs =
#  import ./hspkgs.nix { inherit nixpkgs compiler; };

haskellPackages =
  if   compiler == null
  then pkgs.haskellPackages
  else pkgs.haskell.packages.${compiler};

in

{

 reflex-fltk = haskellPackages.callCabal2nix "reflex-fltk" ./. { };

 # reflex-fltk = haskellPackages.callPackage ./default.nix { };
 #   # ^ nix-build --attr reflex-fltk release.nix

}
