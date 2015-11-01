{ stdenv, fetchurl
, pkgconfig
, libiconv
, libintlOrEmpty

, expat
, fontconfig
, freetype
, glib
, libpng
, pixman
, mesa_noglu
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  name = "cairo-1.14.4";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha256 = "05p75r914d809711yg9rapgmmi4hymzbarhd3w0yrfadhiy9rv7n";
  };

  configureFlags = [
    "--enable-tee"
    "--enable-gl"
    "--enable-xcb"
    "--enable-pdf"
  ];

  preConfigure = ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype}/include/freetype2 -I${freetype}/include|g'
  '';

  nativeBuildInputs = [
    pkgconfig
    libiconv
    libintlOrEmpty
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    glib
    libpng
    mesa_noglu
    xorg.xcbutil
    xorg.libxcb
    xorg.libXrender
    xorg.xlibsWrapper
    zlib
  ];

  propagatedBuildInputs = [
    pixman
    xorg.libX11
    xorg.libXext
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 2D graphics library";
    homepage = http://cairographics.org/;
    license = with licenses; [ lgpl2Plus mpl10 ];
    platforms = platforms.linux;
  };
}
