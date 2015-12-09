{ stdenv, fetchurl
, gettext
, intltool
, pkgconfig

, glib
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
  name = "libgweather-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/${versionMajor}/${name}.tar.xz";
    sha256 = "1l3sra84k5dnavbdbjyf1ar84xmjszpnnldih6mf45kniwpjkcll";
  };

  configureFlags = [
    "--enable-schemas-compile"
    "--enable-compile-warnings"
    "--enable-glibtest"
    "--enable-nls"
    "--enable-rpath"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-introspection"
    "--disable-vala"
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    gdk_pixbuf
    glib
    gtk3
  ];

  buildInputs = [
    atk
    gconf
    gnome3.geocode_glib
    gobjectIntrospection
    libsoup
    libxml2
    pango
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
