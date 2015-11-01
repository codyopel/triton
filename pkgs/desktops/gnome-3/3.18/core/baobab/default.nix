{ stdenv, fetchurl
, intltool
, vala
, libgtop
, pkgconfig
, gtk3, glib
, bash
, makeWrapper
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
    sha256 = "0nhbfs4c1inr7sn1mqmpzanmkz1zz9q05hqf5xydk50fvm9lr4km";
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
    makeWrapper
    file
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
  ];

  preFixup = ''
    wrapProgram "$out/bin/baobab" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Baobab;
    description = "Graphical application to analyse disk usage in any Gnome environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
