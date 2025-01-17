{ stdenv, intltool, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, bash, gtk3, glib, cracklib, libnotify
, itstool, gnome3, librsvg, gdk_pixbuf, libxml2, python
, libcanberra_gtk3, libxslt, libtool, docbook_xsl, libpwquality }:

stdenv.mkDerivation rec {
  name = "gnome-disk-utility-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${versionMajor}/${name}.tar.xz";
    sha256 = "1gyf1cgs67d66s748mbhbbiynclwkwlxzv5iz10rd0jnj8s4dgig";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool
                  libxslt libtool libsecret libpwquality cracklib
                  libnotify libdvdread libcanberra_gtk3 docbook_xsl
                  gdk_pixbuf gnome3.defaultIconTheme
                  librsvg udisks2 gnome3.gnome_settings_daemon
                  gnome3.gsettings_desktop_schemas libxml2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://en.wikipedia.org/wiki/GNOME_Disks;
    description = "A udisks graphical front-end";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
