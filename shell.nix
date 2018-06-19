{ nixpkgs ? import <nixpkgs> {}
, compiler ? "default"
, withProfiling ? false
, withHoogle    ? false 
, development   ? true
}:

/*
*/

########################################
  
let

inherit (nixpkgs) pkgs;
inherit (pkgs)    fetchFromGitHub;
hs = pkgs.haskell.lib;

########################################

  haskellPackagesWithCompiler = 
    if compiler == "default"
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

########################################

/*

[nix-shell]$ cabal repl fltkhs-reflex
Preprocessing library for fltkhs-reflex-0.0.1..
GHCi, version 8.2.2: http://www.haskell.org/ghc/  :? for help
<command line>: can't load .so/.DLL for: /nix/store/p032q22qigxr838snfbsa07hhg50ipln-fltkhs-0.5.4.3/lib/ghc-8.2.2/x86_64-linux-ghc-8.2.2/libHSfltkhs-0.5.4.3-9l3SeZKpar9IlCC4jOt0Tr-ghc8.2.2.so (/nix/store/p032q22qigxr838snfbsa07hhg50ipln-fltkhs-0.5.4.3/lib/ghc-8.2.2/x86_64-linux-ghc-8.2.2/libHSfltkhs-0.5.4.3-9l3SeZKpar9IlCC4jOt0Tr-ghc8.2.2.so: undefined symbol: Fl_Adjuster_New)

*/
