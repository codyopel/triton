{ stdenv, fetchurl
, getopt
, lua
, boost
, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "highlight-3.24";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${name}.tar.bz2";
    sha256 = "1kbraqs2vr2hxj9abpq0zi9w2c98bcjfcrxn9fskzfcxvsbid4jg";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    getopt
    lua
    boost
  ];

  preConfigure = ''
    makeFlags="PREFIX=$out conf_dir=$out/etc/highlight/"
  '';

  meta = {
    description = "Source code highlighting tool";
  };
}
