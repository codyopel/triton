{ stdenv, fetchurl
, zlib
, apngSupport ? false
}:

let
  version = "1.6.19";
in

let
  libpng-apng = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0bgqkac16yhl0zwjzq2zwkixg2l2x3a6blbk3k0wqz0lza2a6jrh";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;
in

stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "1s1mmkl79ghiczi2x2rbnp6y70v4c5pr8g3icxn9h5imymbmc71i";
  };

  postPatch = whenPatched "gunzip < ${libpng-apng} | patch -Np1";

  propagatedBuildInputs = [
    zlib
  ];

  doCheck = true;
  enableParallelBuilding = true;

  passthru = {
    inherit zlib;
  };

  meta = with stdenv.lib; {
    description = "Reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
