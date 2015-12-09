{ stdenv, fetchurl
, pkgconfig
, gnome3
, gtk3
, intltool
, evolution_data_server
, sqlite
, libxml2
, libsoup
, glib
, gnome_online_accounts
}:

stdenv.mkDerivation rec {
  name = "gnome-calendar-3.18.0";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-calendar/3.18/gnome-calendar-3.18.0.tar.xz;
    sha256 = "f7d50fe8d5d3dcc574f0034dba6a64cbb9b3f842faab5978c9d02b38548f355b";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [
    pkgconfig gtk3 intltool evolution_data_server
    sqlite libxml2 libsoup glib gnome3.defaultIconTheme gnome_online_accounts
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calendar;
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
