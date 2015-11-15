{ stdenv, fetchurl
, autoreconfHook
, perl

, bzip2
, popt
, zlib
}:

stdenv.mkDerivation rec {
  name = "librsync-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/librsync/librsync/archive/v${version}.tar.gz";
    sha256 = "1ndgzh9zlf8aaqs5sjxsrlb0lhrgv6zy73pqjd6yh34n2s2rk591";
  };

  configureFlags = [
    "--enable-shared"
    "--enable-largefile"
    "--disable-trace"
  ];

  nativeBuildInputs = [
    autoreconfHook
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

  meta = with stdenv.lib; {
    description = "Implementation of the rsync remote-delta algorithm";
    homepage = http://librsync.sourceforge.net/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}
