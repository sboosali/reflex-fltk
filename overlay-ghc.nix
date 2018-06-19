pkgs: nixpkgs: self: super: {
# ^ `self`/`super` are like `nixpkgs.pkgs.haskell.compiler`.
# ^ `pkgs`/`nixpkgs` are the "parent self/super".
# NOTE `self` for packages and `super` for utilities.
# NOTE this file must be partially applied to the to be a "well-typed overlay";
#      i.e. `((import ./overlay-<...>.nix) pkgs nixpkgs)`


}
