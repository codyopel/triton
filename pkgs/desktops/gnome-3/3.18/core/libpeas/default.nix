{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, glib, gtk3, gobjectIntrospection, python, pygobject
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedBuildInputs = [
    gobjectIntrospection
  ];

  buildInputs =  [
   intltool pkgconfig glib gtk3 gobjectIntrospection python pygobject
   gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    description = "A GObject-based plugins engine";
    homepage = "http://ftp.acc.umu.se/pub/GNOME/sources/libpeas/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
