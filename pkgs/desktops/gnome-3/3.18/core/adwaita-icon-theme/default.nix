{ stdenv, fetchurl
, iconnamingutils
, intltool
, pkgconfig

, gdk_pixbuf
, gnome3
, hicolor_icon_theme
, librsvg
}:

stdenv.mkDerivation rec {
  name = "adwaita-icon-theme-3.18.0";

  src = fetchurl {
    url = mirror://gnome/sources/adwaita-icon-theme/3.18/adwaita-icon-theme-3.18.0.tar.xz;
    sha256 = "5e9ce726001fdd8ee93c394fdc3cdb9e1603bbed5b7c62df453ccf521ec50e58";
  };

  configureFlags = [
    "--enable-nls"
    "--enable-w32-cursors"
    "--disable-l-xl-variants"
  ];

  # Adding gtk3 as a build input will cause the build to ignore
  # GDK_PIXBUF_MODULE_FILE, and look for loaders in the gtk lib directory

  nativeBuildInputs = [
    iconnamingutils
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    # For convenience, we can specify adwaita-icon-theme only in packages
    hicolor_icon_theme
  ];

  buildInputs = [
    gdk_pixbuf
    librsvg
  ];

  # remove a tree of dirs with no files within
  postInstall = ''
    rm -rvf "$out/locale"
  '';

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
