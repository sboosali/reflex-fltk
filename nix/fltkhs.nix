{ opengl ? false
, demos  ? true
}: # ^ fltkhs's cabal flags

self: pkgs:
# ^ `self` is `haskellPackages`, `pkgs` is just `pkgs`.

########################################

# use haskell.lib.add<...> on `cabal2nix`'d fltkhs from Hackage,
# i.e. not manual `default.nix` from locally.

let

utilities = pkgs.lib;

haskell = pkgs.haskell.lib;

# reverse function-application.
ylppa = x: f: f x;

# foldl          :: (b -> (b -> b) -> b) -> (b -> [b -> b] -> b)
# foldlFunctions ::                          b -> [b -> b] -> b
foldlFunctions = builtins.foldl' ylppa;

fltkhs-hackage =
 self.callHackage "fltkhs" "0.5.4.5" { 
 };

fltkhs-local =
 (self.callCabal2nix "fltkhs" ../../fltkhs) {
 }; 

fltkhs-customize = p:
 foldlFunctions p
 [

   (d: haskell.addSetupDepends d
     ((with self; [
       base c2hs Cabal directory filepath
     ]) ++ (with pkgs; [
       autoconf
     ])))

   #(d: haskell.addBuildDepends     d (with self; [  ]))

   (d: haskell.addBuildTools d
     ((with self; [
       c2hs
     ]) ++ (with pkgs; [
       autoconf fltk
     ])))

   (d: haskell.addExtraLibraries d 
     ((with pkgs; [
       fltk libjpeg
     ]) ++ utilities.optionals opengl 
     (with pkgs; [
       mesa
     ])))

 ];

in

fltkhs-customize fltkhs-local

########################################

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
