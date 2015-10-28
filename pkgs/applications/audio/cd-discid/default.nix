{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "cd-discid-${version}";
  version = "1.4";

  src = fetchurl {
    url = "http://linukz.org/download/${name}.tar.gz";
    sha256 = "0qrcvn7227qaayjcd5rm7z0k5q89qfy5qkdgwr5pd7ih0va8rmpz";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALL=install"
  ];

  meta = with stdenv.lib; {
    description = "Gets CDDB discid information from a CD-ROM disc";
    homepage = http://linukz.org/cd-discid.shtml;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
