{ stdenv, fetchurl
, pkgconfig

, gtk2
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

  patches = [
    ./gtkmm-2.24.4-papersize.patch
    ./gtkmm-2.24.4-missing-includes.patch
    ./gtkmm-2.24.4-newer-glibmm.patch
    ./gtkmm-2.24.4-add-list.m4.patch
    ./gtkmm-2.24.4-fix-add-list.m4.patch
    ./gtkmm-2.24.4-cpp11.patch
    ./gtkmm-2.24.4-gdkpixbud-deprecation-warnings.patch
  ];

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    atkmm
    cairomm
    glibmm
    gtk2
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
