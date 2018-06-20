/*
*/

{ nixpkgsFile  ? ./nixpkgs.json
, overlayFiles ? [ ./overlay-nixpkgs.nix ] # later files' attrs take precedence.
, configFiles  ? [ ./config.nix ]          # later files' attrs take precedence.
}:

########################################
let

nixpkgs-bootstrap =
 import <nixpkgs> { };

nixpkgs-pinned-metadata =
 builtins.fromJSON (builtins.readFile nixpkgsFile);
 # $ nix-prefetch-git https://github.com/NixOS/nixpkgs.git > nixpkgs.json

nixpkgs-pinned-source =
 nixpkgs-bootstrap.fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  inherit (nixpkgs-pinned-metadata) rev sha256;
 };

# :: [ Object -> Object -> Object ]
#
overlays =
 map import overlayFiles;

# :: Object
#
# `foldr (//) {}` is right-biased;
# a.k.a. duplicate keys (with conflicting values) resolve to the last key's value.
config =
 nixpkgs-bootstrap.lib.foldr (xs: ys: xs // ys) {}
  (map import configFiles);

nixpkgs-pinned =
 import nixpkgs-pinned-source { inherit overlays config; };

in

nixpkgs-pinned