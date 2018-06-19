pkgs: nixpkgs: 
self: super: 

# ^ `self`/`super` are like `nixpkgs.pkgs.haskellPackages`.
# ^ `pkgs`/`nixpkgs` are the "parent self/super".

# NOTE `self` for packages and `super` for utilities.
# NOTE this file must be partially applied to the to be a "well-typed overlay";
#      i.e. `((import ./overlay-<...>.nix) pkgs nixpkgs)`

let

utilities = import ./utilities.nix self nixpkgs;

in
########################################
{

spiros = self.callCabal2nix "spiros-LOCAL" ../spiros {
};

fltkhs = utilities.callPackageFromGitViaJSON ./fltkhs.json
 {
  inherit (pkgs) mesa;
 };

reflex = nixpkgs.haskell.lib.doJailbreak
 (utilities.callPackageFromGitViaJSON ./reflex.json { });
 # reflex-0.5

}
########################################