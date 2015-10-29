{ fetchurl, stdenv
, pkgconfig
, cairo
, xlibsWrapper
, fontconfig
, freetype
, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "cairomm-1.12.0";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "1k3lb3jwnk5nm4s5cfm5kk8kl4b066chis4inws6k5yxdzn5lhsh";
  };

  buildInputs = [
    pkgconfig
    cairo
    xlibsWrapper
    fontconfig
    freetype
    libsigcxx
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 2D graphics library with support for multiple output devices";
    homepage = http://cairographics.org/;
    license = with licenses; [ lgpl2Plus mpl10 ];
  };
}
