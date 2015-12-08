{ stdenv, fetchurl
, cmake
, perl

, bzip2
, popt
, zlib
}:

stdenv.mkDerivation rec {
  name = "librsync-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/librsync/librsync/archive/v${version}.tar.gz";
    sha256 = "0s91mqzmk64kk7qp9kl9va511lgh9wny92bp74wj10w9888xvi5m";
  };

  nativeBuildInputs = [
    cmake
    perl
  ];

  buildInputs = [
    bzip2
    popt
    zlib
  ];

  crossAttrs = {
    dontStrip = true;
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Implementation of the rsync remote-delta algorithm";
    homepage = http://librsync.sourceforge.net/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}
