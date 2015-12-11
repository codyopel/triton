{ stdenv, fetchurl
, gobjectIntrospection
, intltool
, itstool
, pkgconfig

, glib
, gnome3
, gtk3
, libcanberra_gtk3
, libnotify
, libxml2
, udev
}:

stdenv.mkDerivation rec {
  name = "gnome-bluetooth-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-bluetooth/${versionMajor}/${name}.tar.xz";
    sha256 = "0jaa9nbygdvcqp9k4p4iy2g8x3684s4x9k5nbcmmm11jdn4mn7f5";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-schemas-compile"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-desktop-update"
    "--disable-icon-update"
    "--enable-introspection"
    "--disable-debug"
    "--enable-compile-warnings"
    "--disable-iso-c"
    "--disable-documentation"
  ];

  nativeBuildInputs = [
    intltool
    itstool
    pkgconfig
  ];

  buildInputs = [
    glib
    gnome3.defaultIconTheme
    gnome3.gsettings_desktop_schemas
    gobjectIntrospection
    gtk3
    libcanberra_gtk3
    libnotify
    libxml2
    udev
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Application for managing Bluetooth";
    homepage = https://help.gnome.org/users/gnome-bluetooth;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
