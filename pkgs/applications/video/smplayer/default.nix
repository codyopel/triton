{ stdenv, fetchurl
, qt5
}:

stdenv.mkDerivation rec {
  name = "smplayer-15.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1yx6kikaj9v5aj8aavvrcklx283wl6wrnpl905hjc7v03kgp1ac5";
  };

  patches = [
    ./basegui.cpp.patch
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = [
    qt5.script
  ];

  meta = with stdenv.lib; {
    description = "A complete front-end for MPlayer";
    homepage = http://smplayer.sourceforge.net/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
