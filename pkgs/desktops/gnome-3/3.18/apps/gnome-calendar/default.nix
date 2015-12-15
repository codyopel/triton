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
, librsvg
}:

stdenv.mkDerivation rec {
  name = "gnome-calendar-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calendar/${versionMajor}/${name}.tar.xz";
    sha256 = "1fgjmpk233jyxqajhariwbfq90snbh45dcn2vyzmbyjjk73hgwwn";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-schemas-compile"
    "--enable-compile-warnings"
    "--disable-iso-c"
    "--enable-appstream-util"
  ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  buildInputs = [
    evolution_data_server
    gtk3
    sqlite
    libxml2
    libsoup
    glib
    gnome3.defaultIconTheme
    gnome_online_accounts
    librsvg
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Calendar application for GNOME";
    homepage = https://wiki.gnome.org/Apps/Calendar;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
