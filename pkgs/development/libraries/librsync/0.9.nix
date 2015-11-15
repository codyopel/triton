{ stdenv, fetchurl
, autoreconfHook
, perl

, bzip2
, popt
, zlib
}:

stdenv.mkDerivation rec {
  name = "librsync-${version}";
  version = "0.9.7";

  src = fetchurl {
    url = "https://github.com/librsync/librsync/archive/v${version}.tar.gz";
    sha256 = "1mj1pj99mgf1a59q9f2mxjli2fzxpnf55233pc1klxk2arhf8cv6";
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
