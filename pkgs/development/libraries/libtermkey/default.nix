{ stdenv, fetchzip
, libtool
, pkgconfig

, ncurses
}:

stdenv.mkDerivation rec {
  name = "libtermkey-0.18";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/${name}.tar.gz";
    sha256 = "0a0ih1a114phzmyq6jzgbp03x97463fwvrp1cgnl26awqw3f8sbf";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  nativeBuildInputs = [
    libtool
    pkgconfig
  ];

  buildInputs = [
    ncurses
  ];

  meta = with stdenv.lib; {
    description = "Terminal keypress reading library";
    license = licenses.mit;
  };
}
