{ stdenv, fetchurl
, pkgconfig
, glib
, libxslt
, gtk
, webkitgtk
, json_glib
, rest
, libsecret
, dbus_glib
, gnome_common
, telepathy_glib
, intltool
, dbus_libs
, icu
, autoreconfHook
, libsoup
, docbook_xsl_ns
, docbook_xsl
, gnome3
}:

stdenv.mkDerivation rec {
  name = "gnome-online-accounts-${version}";
  versionMajor = "3.18";
  versionMinor = "2.1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/${versionMajor}/${name}.tar.xz";
    sha256 = "1b6gdq4qcrwcaxdcy3379s0ahsfyqglakzk8xlvq9h2sx9c9q2na";
  };

  NIX_CFLAGS_COMPILE = [
    "-I${dbus_glib}/include/dbus-1.0"
    "-I${dbus_libs}/include/dbus-1.0"
  ];

  preAutoreconf = ''
    sed '/disable-settings/d' -i configure.ac
    sed "/if HAVE_INTROSPECTION/a INTROSPECTION_COMPILER_ARGS = --shared-library=$out/lib/libgoa-1.0.so" -i src/goa/Makefile.am
  '';

  buildInputs = [
    pkgconfig
    glib
    libxslt
    gtk
    webkitgtk
    json_glib
    rest
    gnome_common
    libsecret
    dbus_glib
    telepathy_glib
    intltool
    icu
    libsoup
    autoreconfHook
    docbook_xsl_ns
    docbook_xsl
    gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
