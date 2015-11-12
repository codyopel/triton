{ stdenv, fetchurl
, libintlOrEmpty
, pkgconfig

, cairo
, fontconfig
, freetype
, glib
, gobjectIntrospection
, graphite2
, icu
}:

stdenv.mkDerivation rec {
  name = "harfbuzz-1.0.6";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/${name}.tar.bz2";
    sha256 = "09ivk5m4y09ar4zi9r6db7gp234cy05h0ach7w22g9kqvkxsf5pn";
  };

  configureFlags = [
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-introspection"
    "--with-glib"
    "--with-gobject"
    "--with-cairo"
    "--with-fontconfig"
    "--with-icu"
    "--with-graphite2"
    "--with-freetype"
    "--without-uniscribe"
    "--without-coretext"
  ];

  nativeBuildInputs = [
    pkgconfig
  ] ++ libintlOrEmpty;

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    gobjectIntrospection
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
