{ stdenv, fetchurl
, gettext
, intltool
, pkgconfig

, gnome3
, hicolor_icon_theme
, librsvg
}:

stdenv.mkDerivation rec {
  name = "adwaita-icon-theme-${version}";
  versionMajor = "3.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${versionMajor}/${name}.tar.xz";
    sha256 = "5e9ce726001fdd8ee93c394fdc3cdb9e1603bbed5b7c62df453ccf521ec50e58";
  };

  configureFlags = [
    # nls creates unused directories
    "--disable-nls"
    "--enable-w32-cursors"
    "--disable-l-xl-variants"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    # For convenience, we can specify adwaita-icon-theme only in packages
    hicolor_icon_theme
  ];

  buildInputs = [
    librsvg
  ];

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
