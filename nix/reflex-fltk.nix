{ mkDerivation, base, bytestring, dependent-sum, fltkhs, mtl
, ref-tf, reflex, stdenv, text, transformers
}:
mkDerivation {
  pname = "reflex-fltk";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  enableSeparateDataOutput = true;
  executableHaskellDepends = [
    base bytestring dependent-sum fltkhs mtl ref-tf reflex text
    transformers
  ];
  homepage = "http://github.com/sboosali/reflex-fltk";
  description = "FLTKHS demos. Please scroll to the bottom for more information.";
  license = stdenv.lib.licenses.mit;
}
