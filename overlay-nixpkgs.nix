self: super: {
# ^ `self`/`super` are like `nixpkgs.pkgs`

haskellPackages = super.haskellPackages.override {
  overrides = finalHaskellPackages: priorHaskellPackages:
    (import ./overlay-haskell.nix) self.pkgs super finalHaskellPackages priorHaskellPackages;
  };

}
