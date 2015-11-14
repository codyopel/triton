{ stdenv, fetchurl
, intltool
, pkgconfig

, glib
, gnome_online_accounts
, gobjectIntrospection
, gtk3
, json_glib
, libsoup
, rest
}:

stdenv.mkDerivation rec {
  name = "libzapojit-${version}";
  versionMajor = "0.0";
  versionMinor = "3";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libzapojit/${versionMajor}/${name}.tar.xz";
    sha256 = "0zn3s7ryjc3k1abj4k55dr2na844l451nrg9s6cvnnhh569zj99x";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-debug"
    "--enable-introspection"
    "--enable-nls"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
  ];

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  buildInputs = [
    glib
    gnome_online_accounts
    gobjectIntrospection
    gtk3
    json_glib
    libsoup
    rest
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
