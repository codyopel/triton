{ stdenv, fetchurl }:

with {
  inherit (stdenv.lib)
    optionalString;
};

stdenv.mkDerivation rec {
  version = "0.5.1";
  name = "libmpeg2-${version}";

  src = fetchurl {
    url = "http://libmpeg2.sourceforge.net/files/${name}.tar.gz";
    sha256 = "1m3i322n2fwgrvbs1yck7g5md1dbg22bhq5xdqmjpz5m7j4jxqny";
  };

  # Otherwise clang fails with 'duplicate symbol ___sputc'
  buildFlags = optionalString stdenv.cc.isClang "CFLAGS=-std=gnu89";

  meta = with stdenv.lib; {
    description = "Library for decoding mpeg-2 and mpeg-1 video streams";
    homepage = http://libmpeg2.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
