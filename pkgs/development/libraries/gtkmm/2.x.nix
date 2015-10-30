{ stdenv, fetchurl
, pkgconfig
, gtk
, glibmm
, cairomm
, pangomm
, atkmm
}:

stdenv.mkDerivation rec {
  name = "gtkmm-${version}";
  versionMajor = "2.24";
  versionMinor = "4";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${versionMajor}/${name}.tar.xz";
    sha256 = "1vpmjqv0aqb1ds0xi6nigxnhlr0c74090xzi15b92amlzkrjyfj4";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    glibmm
    gtk
    atkmm
    cairomm
    pangomm
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ interface to the GTK+ graphical user interface library";
    homepage = http://gtkmm.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
