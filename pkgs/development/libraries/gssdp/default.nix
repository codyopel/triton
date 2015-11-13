{ stdenv, fetchurl
, pkgconfig

, libsoup
, glib
, gobjectIntrospection
, gtk3
}:

stdenv.mkDerivation rec {
  name = "gssdp-0.14.11";
  versionMajor = "0.14";
  versionMinor = "11";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${versionMajor}/${name}.tar.xz";
    sha256 = "0njkqr2y7c6linnw4wkc4y2vq5dfkpryqcinbzn0pzhr46psxxbv";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-compile-warnings"
    "--enable-introspection"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--with-gtk"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libsoup
    gobjectIntrospection
    gtk3
  ];

  propagatedBuildInputs = [
    glib
  ];

  meta = with stdenv.lib; {
    description = "API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = licenses.lgpl2;
    platforms = platforms.all;
  };
}
