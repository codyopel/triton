{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.5";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "1awbxzxhzfhkdpy5d3ngxmi0fx91m2dbkyahdj38gb3xiikzrjmz";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.cc.isGNU "-lssp";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = http://doc.libsodium.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
