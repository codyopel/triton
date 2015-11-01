{ stdenv, fetchurl
, vala
, libxslt
, pkgconfig
, glib
, dbus_glib
, gnome3
, libxml2
, intltool
, docbook_xsl_ns
, docbook_xsl
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "dconf-editor-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf-editor/${versionMajor}/${name}.tar.xz";
    sha256 = "0d150lnacipsbwsr4z0l7xdchm3hspiba0c3gnpaqs5h2srbhyb5";
  };

  buildInputs = [
    vala
    libxslt
    pkgconfig
    glib
    dbus_glib
    gnome3.gtk
    libxml2
    gnome3.defaultIconTheme
    intltool
    docbook_xsl
    docbook_xsl_ns
    makeWrapper
    gnome3.dconf
  ];

  preFixup = ''
    wrapProgram "$out/bin/dconf-editor" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
