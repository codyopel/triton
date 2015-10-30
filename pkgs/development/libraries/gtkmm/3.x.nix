{ stdenv, fetchurl
, pkgconfig
, gtk3
, glibmm
, cairomm
, pangomm
, atkmm
, gnome3
, epoxy
}:

stdenv.mkDerivation rec {
  name = "gtkmm-${version}";
  versionMajor = gnome3.version;
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${versionMajor}/${name}.tar.xz";
    sha256 = "0sxq700invkjpksn790gbnl8px8751kvgwn39663jx7dv89s37w2";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    glibmm
    gtk3
    cairomm
    epoxy
  ];

  propagatedBuildInputs = [
    atkmm
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
