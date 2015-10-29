{ stdenv, fetchurl, lzo }:

stdenv.mkDerivation {
  name = "lzop-1.03";

  src = fetchurl {
    url = "http://www.lzop.org/download/${name}.tar.gz";
    sha256 = "1jdjvc4yjndf7ihmlcsyln2rbnbaxa86q4jskmkmm7ylfy65nhn1";
  };

  buildInputs = [
    lzo
  ];

  meta = with stdenv.lib; {
    description = "Fast file compressor";
    homepage = http://www.lzop.org;
    license = licenses.gpl2;
  };
}
