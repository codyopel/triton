{ stdenv, fetchurl
, texinfo
}:

stdenv.mkDerivation rec {
  name = "lzip-1.17";

  src = fetchurl {
    url = "mirror://savannah/lzip/${name}.tar.gz";
    sha256 = "0lh3x964jjldx3piax6c2qzlhfiir5i6rnrcn8ri44rk19g8ahwl";
  };

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O3 CXXFLAGS=-O3";

  buildInputs = [
    texinfo
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A lossless data compressor based on LZMA";
    homepage = "http://www.nongnu.org/lzip/lzip.html";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
