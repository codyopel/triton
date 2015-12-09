{ stdenv, fetchurl
, intltool
, pkgconfig
, libxml2
, bash
, gtk3
, glib
, itstool
, gnome3
, librsvg
, gdk_pixbuf
, mpfr
, gmp
}:

stdenv.mkDerivation rec {
  name = "gnome-calculator-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${versionMajor}/${name}.tar.xz";
    sha256 = "0r2d4xxw5zn0wljaaa7lvkrq1a51y369fklhjqcd1qcw81bmhv68";
  };

  NIX_CFLAGS_COMPILE = [
    "-I${gnome3.glib}/include/gio-unix-2.0"
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  buildInputs = [
    bash
    pkgconfig
    gtk3
    glib
    intltool
    itstool
    libxml2
    gnome3.gtksourceview
    mpfr
    gmp
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    gnome3.gsettings_desktop_schemas
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Calculator;
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
