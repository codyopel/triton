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
    gnome3.dconf
  ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
