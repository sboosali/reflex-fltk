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

spiros = self.callCabal2nix "spiros-LOCAL" ../spiros { };

fltkhs = import ./fltkhs.nix {opengl=false;} self pkgs;

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


# fltkhs = self.callHackage "fltkhs" "0.5.4.5"
#  {
#  };

# fltkhs = utilities.callPackageFromGitViaJSON ./fltkhs.json
#  {
#   inherit (pkgs) mesa;
#  };

reflex = nixpkgs.haskell.lib.doJailbreak
 (utilities.callPackageFromGitViaJSON ./reflex.json { });
 # reflex-0.5

}
########################################

/*

haskell.lib.addSetupDepends     
haskell.lib.addPkgconfigDepends 
haskell.lib.addBuildDepends     
haskell.lib.addExtraLibraries   
haskell.lib.addBuildTools       

*/
