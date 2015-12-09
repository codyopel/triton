{ stdenv, fetchurl
, gobjectIntrospection
, libtool
, pkgconfig
, vala

, glib
, gnome3
, libcanberra
}:

stdenv.mkDerivation rec {
  name = "gsound-${version}";
  versionMajor = "1.0";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gsound/${versionMajor}/${name}.tar.xz";
    sha256 = "0lwfwx2c99qrp08pfaj59pks5dphsnxjgrxyadz065d8xqqgza5v";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-compile-warnings"
    "--disable-Werror"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-introspection"
    "--enable-vala"
  ];

  nativeBuildInputs = [
    gobjectIntrospection
    libtool
    pkgconfig
    vala
  ];

  buildInputs = [
    glib
    libcanberra
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Small library for playing system sounds";
    homepage = https://wiki.gnome.org/Projects/GSound;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
