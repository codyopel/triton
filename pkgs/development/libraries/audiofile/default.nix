{ stdenv, fetchurl
, alsaLib
}:

with {
  inherit (stdenv)
    isLinux;
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "audiofile-0.3.6";

  nativeBuildInputs = optional isLinux alsaLib;

  src = fetchurl {
    url = "http://audiofile.68k.org/${name}.tar.gz";
    sha256 = "0rb927zknk9kmhprd8rdr4azql4gn2dp75a36iazx2xhkbqhvind";
  };

  configureFlags = [
    "--enable-largefile"
    "--disable-werror"
    "--disable-coverage"
    "--disable-valgrind"
    "--disable-docs"
    "--disable-examples"
    "--enable-flac"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for reading and writing audio files in various formats";
    homepage = http://www.68k.org/~michael/audiofile/; 
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
