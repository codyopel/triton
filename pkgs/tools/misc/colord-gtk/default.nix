{ stdenv, fetchurl
, intltool
, pkgconfig

, colord
, glib
, gobjectIntrospection
, gtk3
, lcms2
}:

stdenv.mkDerivation rec {
  name = "colord-gtk-0.1.26";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "0i9y3bb5apj6a0f8cx36l6mjzs7xc0k7nf0magmf58vy2mzhpl18";
  };

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  buildInputs = [
    colord
    glib
    gobjectIntrospection
    gtk3
    lcms2
  ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
