{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libjpeg-2014-01-19";
  version = "9a";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${version}.tar.gz";
    sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
  };

  meta = {
    description = "A library that implements the JPEG image file format";
    homepage = http://www.ijg.org/;
    license = stdenv.lib.licenses.free;
  };
}
