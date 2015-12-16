{ stdenv, fetchurl

, libogg
, libpng
}:

stdenv.mkDerivation rec {
  name = "libkate-0.4.1";

  src = fetchurl {
    url = "http://libkate.googlecode.com/files/${name}.tar.gz";
    sha256 = "0s3vr2nxfxlf1k75iqpp4l78yf4gil3f0v778kvlngbchvaq23n4";
  };

  buildInputs = [
    libogg
    libpng
  ];

  meta = {
    description = "Library for encoding and decoding Kate streams";
    homepage = http://code.google.com/p/libkate;
    maintainers = [ ];
  };
}
