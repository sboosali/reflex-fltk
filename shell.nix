{ nixpkgs       ? import <nixpkgs> {}
, compiler      ? null                # [e.g.] --attrstr compiler ghc842
, withProfiling ? false
, withHoogle    ? false 
, development   ? true
}:

/*
*/

########################################

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

  
let

inherit (nixpkgs) pkgs;
inherit (pkgs)    fetchFromGitHub;
hs = pkgs.haskell.lib;

########################################

  haskellPackagesWithCompiler = 
    if compiler == null
    then pkgs.haskellPackages
    else pkgs.haskell.packages.${compiler};

  haskellPackagesWithProfiling = 
    if withProfiling
    then haskellPackagesWithCompiler.override {
           overrides = self: super: {
             mkDerivation = args: super.mkDerivation (args // { enableLibraryProfiling = true; });
           };
         }
    else haskellPackagesWithCompiler;
                 
  haskellPackagesWithHoogle =
    if withHoogle
    then haskellPackagesWithProfiling.override {
           overrides = self: super: {
             ghc = super.ghc // { withPackages = super.ghc.withHoogle; };
             ghcWithPackages = self.ghc.withPackages;
           };
         }
    else haskellPackagesWithProfiling;

########################################

  modifiedHaskellPackages = haskellPackagesWithHoogle.override {
    overrides = self: super: {

      spiros = self.callCabal2nix "spiros" ../spiros {};

      fltkhs = self.callPackage (super.fetchFromGitHub (import ./fltkhs.json)) {
        inherit (self.pkgs) mesa;
      };
      
      reflex = hs.doJailbreak (super.fetchFromGitHub (import ./reflex.json));
      
    };
  };

/*
$ nix-prefetch-git https://github.com/reflex-frp/reflex
*/


########################################
  
  installationDerivation = modifiedHaskellPackages.callPackage ./. {};

  # development environment
  # for `nix-shell --pure`
  developmentDerivation = hs.linkWithGold 
      (hs.addBuildDepends installationDerivation developmentPackages);
      # addBuildTools v addSetupDepends v addBuildDepends

  developmentPackages = developmentHaskellPackages
                     # ++ developmentEmacsPackages 
                     ++ developmentSystemPackages;

  developmentSystemPackages = with pkgs; [
  
      cabal-install
  
      fltk
      # for interpreter, 'undefined symbols' linker errors

      inotify-tools
      # since fltkhs breaks ghci 
  
      # emacs
      # git
      
    ];

   developmentHaskellPackages = with modifiedHaskellPackages; [
  
      # ghcid
      # ghc-mod

      hasktags
  
    ];

   # developmentHaskellPackages = with Packages; [
   #    dante
   #  ];

  env = hs.shellAware developmentDerivation;
        # if pkgs.lib.inNixShell then drv.env else drv;

in

  env
