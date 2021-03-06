pkgs: nixpkgs: 

self: super: 

# ^ `self`/`super` are like `nixpkgs.pkgs.haskellPackages`.
# ^ `pkgs`/`nixpkgs` are the "parent self/super".

# NOTE `self` for packages and `super` for utilities.
# NOTE this file must be partially applied to the to be a "well-typed overlay";
#      i.e. `((import ./overlay-<...>.nix) pkgs nixpkgs)`

let

haskell   = nixpkgs.haskell.lib;

utilities = import ./utilities.nix self nixpkgs;

in
########################################
{

spiros = self.callCabal2nix "spiros" ~/haskell/spiros { };
# ../../../spiros/

reflex = nixpkgs.haskell.lib.doJailbreak
 (utilities.callPackageFromGitViaJSON ./reflex.json { });
 # reflex-0.5

# reflex-host = (utilities.callHaskellPackageFromGitViaJSON ./reflex-host.json { });

reflex-host = # nixpkgs.haskell.lib.doJailbreak 
 (self.callCabal2nix "reflex-host" ../../../reflex-host { 
 });

# reflex-basic-host = (utilities.callPackageFromGitViaJSON ./reflex-basic-host.json { });

reflex-basic-host = nixpkgs.haskell.lib.doJailbreak 
 (self.callCabal2nix "reflex-basic-host" ../../../reflex-basic-host { 
 });
# ~/haskell/reflex-basic-host
  # $ diff reflex-basic-host.nix <(cabal2nix .)

fltkhs = import ./fltkhs.nix {opengl=false;} self pkgs;

# fltkhs = self.callHackage "fltkhs" "0.5.4.5"
#  {
#  };

# fltkhs = utilities.callPackageFromGitViaJSON ./fltkhs.json
#  {
#   inherit (pkgs) mesa;
#  };

stateWriter = nixpkgs.haskell.lib.dontCheck super.stateWriter;
  # stateWriter-0.2.10

}
########################################

/*





allBuildInputs

    { setupHaskellDepends ? [], extraLibraries ? []
    , librarySystemDepends ? [], executableSystemDepends ? []
    , pkgconfigDepends ? [], libraryPkgconfigDepends ? []
    , executablePkgconfigDepends ? [], testPkgconfigDepends ? []
    , benchmarkPkgconfigDepends ? [], testDepends ? []
    , testHaskellDepends ? [], testSystemDepends ? []
    , testToolDepends ? [], benchmarkDepends ? []
    , benchmarkHaskellDepends ? [], benchmarkSystemDepends ? []
    , benchmarkToolDepends ? [], buildDepends ? []
    , libraryHaskellDepends ? [], executableHaskellDepends ? []
    }








callPackageWithDependencies = haskell: 
 (self.callPackage { })

addDependencies = 
builtins.foldl' (x: f: f x)
 [
   (d: haskell.addSetupDepends     d [  ])
   (d: haskell.addPkgconfigDepends d [  ])
   (d: haskell.addBuildDepends     d [  ])
   (d: haskell.addExtraLibraries   d [  ])
   (d: haskell.addBuildTools       d [  ])
 ];

= drv: 
{
 setupDepends     ? [  ],
 pkgconfigDepends ? [  ],
 buildDepends     ? [  ],
 extraLibraries   ? [  ],
 buildTools       ? [  ],

 coverage ? null,
haddock
test
benchmark

jailbreak
distribute

libraryProfiling    ? null
executableProfiling ? null
enableLibraryProfiling
enableExecutableProfiling

deadCodeElimination
  enableDeadCodeElimination

patches
  appendPatches 

  hyperlinkSource


sharedLibraries
sharedExecutables
 enableSharedLibraries
 enableSharedExecutables

staticLibraries
  enableStaticLibraries

strip ? null
 doStrip

dwarfDebugging
 enableDWARFDebugging

sdist
 sdistTarball

goldLinker ? false
 linkWithGold

staticExecutables
 justStaticExecutables

# buildFromSdist

strict ? false
 buildStrictly

checkUnusedPackages ? false
 checkUnusedPackages

rebuild ? false
 triggerRebuild



configureFlagsEnabled ? [ ]
configureFlagsDisabled ? [ ]

buildFlagsEnabled ? [ ]
buildFlagsDisabled ? [ ]



}: 


/* `overrideCabal` alters the arguments to `mkDerivation`.
* /

overrideCabal drv (d:
 {
   buildFlags = (d.buildFlags or []) ++ xs; 
 } // (
   if coverage == null then {} else { doCoverage = coverage; }
 )

 (
   (  if distribute == true  then doDistribute   else
      if distribute == false then dontDistribute else id
   ) ...


appendConfigureFlag
removeConfigureFlag


  doDistribute = drv: overrideCabal drv (drv: { hydraPlatforms = drv.platforms or ["i686-linux" "x86_64-linux" "x86_64-darwin"]; });

 } // (if doCoverage == null then {} else { inherit doCoverage; }
 ) // ...

{
   doCoverage = ????
 });


*/

/*

haskell.lib.addSetupDepends     
haskell.lib.addPkgconfigDepends 
haskell.lib.addBuildDepends     
haskell.lib.addExtraLibraries   
haskell.lib.addBuildTools       

*/
