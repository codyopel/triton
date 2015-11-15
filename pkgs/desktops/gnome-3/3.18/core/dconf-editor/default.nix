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
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf-editor/${versionMajor}/${name}.tar.xz";
    sha256 = "0xdwi7g1xdmgrc9m8ii62fp2zj114gsfpmgazlnhrcmmfi97z5d7";
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
