{ stdenv, fetchurl
, intltool
, enchant
, isocodes
, pkgconfig
, gtk3
, glib
, bash
, itstool
, libsoup
, libxml2
, gnome3
, librsvg
, gdk_pixbuf
, file
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  buildInputs = [
    pkgconfig
    gtk3
    glib
    intltool
    itstool
    enchant
    isocodes
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    libsoup
    gnome3.libpeas
    gnome3.gtksourceview
    libxml2
    gnome3.gsettings_desktop_schemas
    file
  ];

  preFixup = ''
    gtk3AppsWrapperArgs+=("--prefix LD_LIBRARY_PATH : ${gnome3.libpeas}/lib:${gnome3.gtksourceview}/lib")
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gedit;
    description = "Official text editor of the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
