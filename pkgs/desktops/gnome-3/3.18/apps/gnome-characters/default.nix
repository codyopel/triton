{ stdenv, fetchurl
, pkgconfig

, gnome3
, gtk3
, wrapGAppsHook
, intltool
, gjs
, gdk_pixbuf
, librsvg
, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "gnome-characters-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${versionMajor}/${name}.tar.xz";
    sha256 = "1b4v1c2jqrv86bnhmpqib5q670ibygrx9f0idj5sgz0zdjxkj60n";
  };

  buildInputs = [
    pkgconfig
    gtk3
    wrapGAppsHook
    intltool
    gjs
    gdk_pixbuf
    librsvg
    gnome3.defaultIconTheme
    gobjectIntrospection
  ];

  meta = with stdenv.lib; {
    description = "Utility to find and insert unusual characters";
    homepage = https://wiki.gnome.org/Design/Apps/CharacterMap;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
