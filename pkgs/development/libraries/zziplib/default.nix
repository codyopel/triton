{ fetchurl, stdenv
, perl
, python
, xmlto
, zip
, zlib
}:

stdenv.mkDerivation rec {
  name = "zziplib-0.13.62";

  src = fetchurl {
    url = "mirror://sourceforge/zziplib/${name}.tar.bz2";
    sha256 = "0nsjqxw017hiyp524p9316283jlf5piixc1091gkimhz38zh7f51";
  };

  patchPhase = ''
    sed -i -e s,--export-dynamic,, configure
  '';

  buildInputs = [ perl python zip xmlto zlib ];

  doCheck = true;

  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Library to extract data from files archived in a zip file";
    homepage = http://zziplib.sourceforge.net/;
    license = with licenses; [ lgpl2Plus mpl11 ];
    maintainers = [ ];
    platforms = python.meta.platforms;
  };
}