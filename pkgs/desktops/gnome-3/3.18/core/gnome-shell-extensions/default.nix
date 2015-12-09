{ stdenv, fetchurl
, intltool
, libgtop
, pkgconfig
, gtk3
, glib
, bash
, itstool
, gnome3
, file
}:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${versionMajor}/${name}.tar.xz";
    sha256 = "0qfzi85j39dfj9yczghkhd8xbyaqf3lvi758ad4c1n3fi7y4ylfc";
  };

  buildInputs = [
    pkgconfig
    gtk3
    glib
    libgtop
    intltool
    itstool
    file
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
