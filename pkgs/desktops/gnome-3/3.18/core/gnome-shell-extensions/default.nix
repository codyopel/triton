{ stdenv, fetchurl
, intltool
, libgtop
, pkgconfig
, gtk3
, glib
, bash
, makeWrapper
, itstool
, gnome3
, file
}:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${versionMajor}/${name}.tar.xz";
    sha256 = "1hhwz8gyl6bpi8nky24k040k0692zcnd8blinll8v00c1i13axbs";
  };

  buildInputs = [
    pkgconfig
    gtk3
    glib
    libgtop
    intltool
    itstool
    makeWrapper
    file
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
