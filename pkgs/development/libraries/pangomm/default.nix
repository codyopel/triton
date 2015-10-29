{ stdenv, fetchurl
, pkgconfig
, pango
, glibmm
, cairomm
, libpng
, cairo
}:

stdenv.mkDerivation rec {
  name = "pangomm-${version}";
  versionMajor = "2.38";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/pangomm/${versionMajor}/${name}.tar.xz";
    sha256 = "12xwjvqfxhqblcv7641k0l6r8n3qifnrx8w9571izn1nbd81iyzg";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    cairomm
  ];

  buildInputs = [
    pango
    glibmm
    libpng
    cairo
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ interface to the Pango text rendering library";
    homepage = http://www.pango.org/;
    license = with licenses; [ lgpl2 lgpl21 ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
