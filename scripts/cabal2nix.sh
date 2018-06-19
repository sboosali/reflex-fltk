#!/bin/bash

for CABAL_FILE in *.cabal; do
 NIX_FILE="${CABAL_FILE%.*}.nix"
 cabal2nix . > "${NIX_FILE}"
 cat "${NIX_FILE}"
 echo -e "\n(${NIX_FILE})"
done

