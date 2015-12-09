{ stdenv, fetchurl, gnome3, pkgconfig, gtk3, intltool, glib
, udev, itstool, libxml2, libnotify, libcanberra_gtk3
, gobjectIntrospection
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

  buildInputs = [ pkgconfig intltool glib gtk3 udev libxml2 gnome3.defaultIconTheme
                  gnome3.gsettings_desktop_schemas itstool
                  libnotify libcanberra_gtk3
                  gobjectIntrospection ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-bluetooth/stable/index.html.en;
    description = "Application that let you manage Bluetooth in the GNOME destkop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
