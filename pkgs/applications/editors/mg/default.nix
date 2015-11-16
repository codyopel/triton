{ fetchurl, stdenv
, pkgconfig

, libbsd
, ncurses
}:

stdenv.mkDerivation rec {
  name = "mg-20150323";

  src = fetchurl {
    url = "http://homepage.boetes.org/software/mg/${name}.tar.gz";
    sha256 = "1yrs5i6d37xski0qj4kwsinzjza5z8nxjip4cbqjc51ygpa286yp";
  };

  postPatch = ''
    # Remove OpenBSD specific easter egg
    sed -e 's/theo\.o//' -i GNUmakefile
    sed -e '/theo_init/d' -i main.c

    # Remove hardcoded paths
    sed -e 's|/usr/bin/||' -i GNUmakefile

    # Use ncurses instead of curses
    sed -e 's/curses/ncurses/' -i GNUmakefile
  '';

  makefile = "GNUmakefile";

  makeFlags = [
    "prefix=$(out)"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libbsd
    ncurses
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Micro GNU/emacs, an EMACS style editor";
    homepage = http://homepage.boetes.org/software/mg/;
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
