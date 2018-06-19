self: super: rec {

/* e.g.

(shell command)

  $ nix-prefetch-git > https://github.com/.../PACKAGE > PACKAGE.json

(nix expression)

  > (callPackageFromGithubJSON ./PACKAGE.json)

*/
callPackageFromGitViaJSON = p:
 self.callPackage (super.pkgs.fetchgit (importPrefetched p));

importPrefetched = p:
 matchPrefetched (super.lib.importJSON p);

/* safer:
- default missing optional parameters.
- ignore present irrelevant parameters.
*/
matchPrefetched = { url, rev, sha256, fetchSubmodules ? false, ... }:
 { inherit url rev sha256 fetchSubmodules; };

}