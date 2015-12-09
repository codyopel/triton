{ stdenv, fetchurl
, intltool
, vala
, libgtop
, pkgconfig
, gtk3, glib
, bash
, itstool
, libxml2
, gnome3
, librsvg
, gdk_pixbuf
, file
}:

stdenv.mkDerivation rec {
  name = "baobab-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/baobab/${versionMajor}/${name}.tar.xz";
    sha256 = "1da4bdkw5bnxansl1xr4lb03d6f4h0a0qaba8i3p3rwhcd191b62";
  };

  NIX_CFLAGS_COMPILE = [
    "-I${gnome3.glib}/include/gio-unix-2.0"
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  buildInputs = [
    vala
    pkgconfig
    gtk3
    glib
    libgtop
    intltool
    itstool
    libxml2
    gnome3.gsettings_desktop_schemas
    file
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Baobab;
    description = "Graphical application to analyse disk usage in any Gnome environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
