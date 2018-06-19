{ mkDerivation, base, bytestring, fltkhs, stdenv, text }:
mkDerivation {
  pname = "reflex-fltk";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring fltkhs text ];
  homepage = "http://github.com/deech/fltkhs-demos";
  description = "FLTKHS demos. Please scroll to the bottom for more information.";
  license = stdenv.lib.licenses.mit;
}
