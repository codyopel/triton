{ stdenv, fetchurl
, pkgconfig
, file
, intltool
, gobjectIntrospection
, glib
, clutter_gtk
, clutter-gst_2
, gnome3
, gtksourceview
, libmusicbrainz
, webkitgtk
, libmusicbrainz5
, icu
, gst_all_1
, gdk_pixbuf
, librsvg
, gtk3
}:

stdenv.mkDerivation rec {
  name = "sushi-${version}";
  versionMajor = "3.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${versionMajor}/${name}.tar.xz";
    sha256 = "174fc0jh5q8712flmhggi0dd4vbn13hrr94dyapj7gshx4mzjkbz";
  };

  propagatedUserEnvPkgs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  buildInputs = [
    pkgconfig
    file
    intltool
    gobjectIntrospection
    glib
    gtk3
    clutter_gtk
    clutter-gst_2
    gnome3.gjs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtksourceview
    gdk_pixbuf
    librsvg
    gnome3.defaultIconTheme
    libmusicbrainz5
    webkitgtk
    gnome3.evince
    icu
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A quick previewer for Nautilus";
    homepage = "http://en.wikipedia.org/wiki/Sushi_(software)";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
