{ stdenv, fetchurl
, intltool
, pkgconfig

, libxml2
, gtk3
, libsoup
, gconf
, pango
, gdk_pixbuf
, gobjectIntrospection
, atk
, tzdata
, gnome3
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [
    "--enable-nls"
    "--enable-introspection=yes"
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  propagatedBuildInputs = [
    libxml2
    gtk3
    libsoup
    gconf
    pango
    gdk_pixbuf
    atk
    gnome3.geocode_glib
  ];

  buildInputs = [
    gobjectIntrospection
  ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
