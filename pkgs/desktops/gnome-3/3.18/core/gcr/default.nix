{ stdenv, fetchurl
, intltool
, libxslt
, pkgconfig

, atk
, dbus_glib
, gdk_pixbuf
, glib
, gobjectIntrospection
, gnome3
, gnupg
, gtk3
, libgcrypt
, libtasn1
, p11_kit
, pango
, vala
}:

stdenv.mkDerivation rec {
  name = "gcr-${version}";
  versionMajor = "3.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/${versionMajor}/${name}.tar.xz";
    sha256 = "006f6xbd3jppkf9avg83mpqdld5d0z6mr0sm81lql52mmyjnvlfl";
  };

  nativeBuildInputs = [
    intltool
    libxslt
    pkgconfig
  ];

  propagatedBuildInputs = [
    p11_kit
  ];

  buildInputs = [
    atk
    dbus_glib
    gdk_pixbuf
    glib
    gnupg
    gobjectIntrospection
    gtk3
    libgcrypt
    libtasn1
    pango
    vala
  ];

  doCheck = false;
  enableParallelBuilding = false; # issues on hydra

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
