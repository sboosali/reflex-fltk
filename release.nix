{ compiler ? null # [e.g.] --attrstr compiler ghc842
}:

let

  nixpkgs-bootstrap = import <nixpkgs> { };

  nixpkgs-pinned-metadata = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  nixpkgs-pinned-source = nixpkgs-bootstrap.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (nixpkgs-pinned-metadata) rev sha256;
  }; # $ nix-prefetch-git https://github.com/NixOS/nixpkgs.git > nixpkgs.json

  overlays = [ (import ./overlay-nixpkgs.nix) ];

  nixpkgs-pinned = import nixpkgs-pinned-source { inherit overlays; };

  pkgs = nixpkgs-pinned;

  haskellPackages =
      if   compiler == null
      then pkgs.haskellPackages
      else pkgs.haskell.packages.${compiler};

in

{
 reflex-fltk = haskellPackages.callPackage ./default.nix { };
 # ^ nix-build --attr reflex-fltk release.nix
}
