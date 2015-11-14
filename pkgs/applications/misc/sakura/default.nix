{ stdenv, fetchurl
, cmake
, perl
, pkgconfig

, gdk_pixbuf
, gnome3
, gtk3
}:

stdenv.mkDerivation rec {
  name = "sakura-${version}";
  version = "3.3.0";

  src = fetchurl {
    url = "http://launchpad.net/sakura/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "0rzjnlzwlsi309plqp63r2bb6kxr0lam1v0s73c74zwms8gik3a1";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkgconfig
  ];

  buildInputs = [
    gnome3.vte
    gtk3
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A terminal emulator based on GTK and VTE";
    homepage    = http://www.pleyades.net/david/projects/sakura;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.linux;
  };
}
