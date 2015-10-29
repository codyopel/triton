{ stdenv, fetchurl
, linkStatic ? false
}:

stdenv.mkDerivation rec {
  name = "bzip2-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "http://www.bzip.org/${version}/bzip2-${version}.tar.gz";
    sha256 = "1kfrc7f0ja9fdn6j1y6yir6li818npy6217hvr3wzmnmzhs8z152";
  };

  builder = ./builder.sh;

  prePatch = ''
    substituteInPlace Makefile --replace '$(PREFIX)/man' '$(PREFIX)/share/man'
  '';

  makeFlags = [
    (if linkStatic then "LDFLAGS=-static" else null)
    (if stdenv.cc.isClang then
      "CC=clang"
    else
      "CC=gcc")
  ];

  inherit linkStatic;

  sharedLibrary = !(stdenv ? isStatic) && !linkStatic;

  crossAttrs = {
    patchPhase = ''
      sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
      sed -i -e 's/CC=gcc/CC=${stdenv.cross.config}-gcc/' \
        -e 's/AR=ar/AR=${stdenv.cross.config}-ar/' \
        -e 's/RANLIB=ranlib/RANLIB=${stdenv.cross.config}-ranlib/' \
        -e 's/bzip2recover test/bzip2recover/' \
        Makefile*
    '';
  };

  meta = with stdenv.lib; {
    description = "high-quality data compression program";
    homepage = http://www.bzip.org;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
