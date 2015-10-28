{stdenv, fetchurl
, pkgconfig

, curl
, libjpeg
, libpng
, lirc
, ncurses
, readline
, shared_mime_info
, xineLib
, xorg
}:

stdenv.mkDerivation rec {
  name = "xine-ui-0.99.9";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "18liwmkbj75xs9bipw3vr67a7cwmdfcp04v5lph7nsjlkwhq1lcd";
  };

  patchPhase = ''
    sed -e '/curl\/types\.h/d' -i src/xitk/download.c
  '';

  configureFlags = [
    "--with-readline=${readline}"
  ];
  
  LIRC_CFLAGS="-I${lirc}/include";
  LIRC_LIBS="-L ${lirc}/lib -llirc_client";
  
  nativeBuildInputs = [
    pkgconfig
    shared_mime_info
  ];

  buildInputs = [
    curl
    libjpeg
    libpng
    lirc
    ncurses
    readline
    xineLib
    xorg.xlibsWrapper
    xorg.libXext
    xorg.libXv
    xorg.libXxf86vm
    xorg.libXtst
    xorg.inputproto
    xorg.libXinerama
    xorg.libXi
    xorg.libXft
  ];

  enableParallelBuilding = true;

  meta = { 
    homepage = http://www.xine-project.org/;
    description = "Xlib-based interface to Xine, a video player";
  };
}