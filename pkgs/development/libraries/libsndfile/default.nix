{ stdenv, fetchurl
, pkgconfig

, flac
, libogg
, libvorbis
}:

stdenv.mkDerivation rec {
  name = "libsndfile-1.0.26";

  src = fetchurl {
    url = "http://www.mega-nerd.com/libsndfile/files/${name}.tar.gz";
    sha256 = "14jhla289cj45946h0hq2an0a9g4wkwb3v4571bla6ixfvn20rfd";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    flac
    libogg
    libvorbis
  ];

  NIX_CFLAGS_LINK = [
   "-logg"
   "-lvorbis"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for reading and writing sampled sound files";
    homepage = http://www.mega-nerd.com/libsndfile/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
