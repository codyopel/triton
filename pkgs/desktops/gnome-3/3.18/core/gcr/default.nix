{ stdenv, fetchurl
, pkgconfig
, intltool
, gnupg
, p11_kit
, glib
, libgcrypt
, libtasn1
, dbus_glib
, gtk3
, pango
, gdk_pixbuf
, atk
, gobjectIntrospection
, makeWrapper
, libxslt
, vala
, gnome3
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

  propagatedBuildInputs = [
    p11_kit
  ];

  buildInputs = [
    pkgconfig
    intltool
    gnupg
    glib
    gobjectIntrospection
    libxslt
    libgcrypt
    libtasn1
    dbus_glib
    gtk3
    pango
    gdk_pixbuf
    atk
    makeWrapper
    vala
  ];

  doCheck = false;
  enableParallelBuilding = false; # issues on hydra

  preFixup = ''
    wrapProgram "$out/bin/gcr-viewer" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
