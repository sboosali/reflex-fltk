{ compiler ? null # [e.g.] --attrstr compiler ghc842
}:

let

pkgs =
 import ./nixpkgs.nix { };

# hspkgs =
#  import ./hspkgs.nix { inherit nixpkgs compiler; };

haskellPackages =
  if   compiler == null
  then pkgs.haskellPackages
  else pkgs.haskell.packages.${compiler};

in

{
 reflex-fltk = haskellPackages.callPackage ./default.nix { };
   # ^ nix-build --attr reflex-fltk release.nix
}
