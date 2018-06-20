{ nixpkgs       ? import ./nix/nixpkgs.nix {}
, compiler      ? null                # [e.g.] --argstr compiler ghc843
, withProfiling ? true # false
, withHoogle    ? true # false 
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
    if   compiler == null
    then pkgs.haskellPackages
    else pkgs.haskell.packages.${compiler};

haskellPackagesWithProfiling = 
    if   withProfiling
    then haskellPackagesWithCompiler.override
         {
           overrides = self: super:
           {
             mkDerivation = args:
               super.mkDerivation (args //
                 {
                   enableLibraryProfiling = true;
                 });
           };
         }
    else haskellPackagesWithCompiler;
       
haskellPackagesWithHoogle =
    if   withHoogle
    then haskellPackagesWithProfiling.override
         {
           overrides = self: super:
             {
               ghcWithPackages = self.ghc.withPackages;
               ghc = super.ghc //
                 {
                   withPackages = super.ghc.withHoogle;
                 };
             };
         }
    else haskellPackagesWithProfiling;

########################################

modifiedHaskellPackages =
 haskellPackagesWithHoogle.override
   {
     overrides = (import ./nix/overlay-haskell.nix pkgs nixpkgs);
   };

########################################
  
  installationDerivation =
    modifiedHaskellPackages.callCabal2nix "reflex-fltk" ./. {};

  # development environment
  # for `nix-shell --pure`
  developmentDerivation =
    pkgs.haskell.lib.linkWithGold 
      (pkgs.haskell.lib.addBuildDepends installationDerivation developmentPackages);
      # addBuildTools v addSetupDepends v addBuildDepends

  developmentPackages =
       developmentHaskellPackages
    ++ developmentSystemPackages;
                     # ++ developmentEmacsPackages 

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
