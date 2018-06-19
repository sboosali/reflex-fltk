{ nixpkgs       ? import ./nixpkgs.nix {}
, compiler      ? null                # [e.g.] --attrstr compiler ghc842
, withProfiling ? false
, withHoogle    ? false 
, development   ? true
}:

/*
*/

########################################
let

inherit (nixpkgs) pkgs;
 # pkgs = nixpkgs.pkgs;

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

modifiedHaskellPackages =
 haskellPackagesWithHoogle.override {
  overrides = (import ./overlay-haskell.nix pkgs nixpkgs);
 };

########################################
  
  installationDerivation = modifiedHaskellPackages.callPackage ./default.nix {};

  # development environment
  # for `nix-shell --pure`
  developmentDerivation = pkgs.haskell.lib.linkWithGold 
      (pkgs.haskell.lib.addBuildDepends installationDerivation developmentPackages);
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

      # hasktags
  
    ];

   # developmentHaskellPackages = with Packages; [
   #    dante
   #  ];

  env =
   pkgs.haskell.lib.shellAware developmentDerivation;
        # if pkgs.lib.inNixShell then drv.env else drv;

in

  env
