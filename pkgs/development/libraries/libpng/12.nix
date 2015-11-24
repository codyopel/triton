{ stdenv, fetchurl
, zlib
}:

assert !(stdenv ? cross) -> zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.54";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "0wnjy7gqn0f24qrlggs7kl0ij59by413j1xmqp12n3vqh9j531fg";
  };

  configureFlags = "--enable-static";

  propagatedBuildInputs = [ 
    zlib
  ];

  crossAttrs = stdenv.lib.optionalAttrs (stdenv.cross.libc == "libSystem") {
    propagatedBuildInputs = [];
    passthru = {};
  };

  passthru = {
    inherit zlib;
  };

  dontDisableStatic = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    maintainers = with maintainers; [ ];
    branch = "1.2";
  };
}
