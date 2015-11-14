{ fetchurl, stdenv
, pkgconfig

, cairo
, clutter
, clutter_gtk
, glib
, gobjectIntrospection
, gtk3
#, libmemphis
, libsoup
, sqlite
}:

stdenv.mkDerivation rec {
  name = "libchamplain-${version}";
  versionMajor = "0.12";
  versionMinor = "11";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libchamplain/${versionMajor}/${name}.tar.xz";
    sha256 = "19aadn4lh6mzpz2qzi5l1qcbi11a57qqv1zxp2n10z4nin4287l5";
  };

  configureFlags = [
    "--enable-glibtest"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-compile-warnings"
    "--disable-maintainer-mode"
    "--enable-introspection"
    "--disable-debug"
    "--disable-maemo"
    "--enable-gtk"
    "--disable-memphis"
    "--disable-vala"
    "--disable-vala-demos"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    cairo
    clutter
    gobjectIntrospection
    libsoup
    sqlite
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    clutter_gtk
  ];

  meta = with stdenv.lib; {
    description = "C library providing a ClutterActor to display maps";
    homepage = http://projects.gnome.org/libchamplain/;
    license = licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = platforms.gnu;
    inherit version;
  };
}
