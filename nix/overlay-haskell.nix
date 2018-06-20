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

/*
foldl :: (b -> a -> b) -> (b -> t a -> b)

foldl :: (b -> (b -> b) -> b) -> (b -> [b -> b] -> b)

let y = foldl (&) x [f,g,h]
x,y   :: b
f,g,h :: (b -> b)

x == foldl (&) x []

x == foldl (&) x [id,id,...]

z == foldl (&) x [const y, const z,...]

utilities.foldl = builtins.foldl' (x: f: f x)

*/

# use haskell.lib.add<...> on `cabal2nix`'d fltkhs from Hackage,
# i.e. not manual `default.nix` from locally.

fltkhs = builtins.foldl' (x: f: f x)
 (self.callHackage "fltkhs" "0.5.4.5" { })
 [
   (d: haskell.addSetupDepends     d ((with self; [
     base c2hs Cabal directory filepath
   ]) ++ (with pkgs; [
     autoconf 
   ])))

   # (d: haskell.addSetupTools       d (with pkgs; [  ]))
   #(d: haskell.addPkgconfigDepends d (with pkgs; [  ]))

   #(d: haskell.addBuildDepends     d (with self; [  ]))

   (d: haskell.addBuildTools d
    ( (with self; [ c2hs ]) ++
      (with pkgs; [ autoconf fltk ])
    )
   )

   (d: haskell.addExtraLibraries   d ((with pkgs; [
     fltk libjpeg 
   ]) ++ nixpkgs.lib.optionals false [ # flags.opengl
     pkgs.mesa 
   ]))

 ];

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
