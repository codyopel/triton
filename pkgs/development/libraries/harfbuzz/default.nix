{ stdenv, fetchurl
, libintlOrEmpty
, pkgconfig

, cairo
, fontconfig
, freetype
, glib
, graphite2
, icu
}:

stdenv.mkDerivation rec {
  name = "harfbuzz-1.0.4";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/${name}.tar.bz2";
    sha256 = "10a3yw6h6saqv17d2k74qk1zmpimrmpmxw90g4x0vh77aws3fc5h";
  };

  configureFlags = [
    "--with-graphite2=yes"
    "--with-icu=yes"
  ];

  nativeBuildInputs = [
    libintlOrEmpty
    pkgconfig
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    glib
    graphite2
    icu
  ];

  meta = with stdenv.lib; {
    description = "An OpenType text shaping engine";
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
