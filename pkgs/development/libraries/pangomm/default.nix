{ stdenv, fetchurl
, pkgconfig

, cairo
, cairomm
, glibmm
, libpng
, pango
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

  configureFlags = [
    "--disable-deprecated-api"
    "--disable-documentation"
    "--without-libstdc-doc"
    "--without-libsigc-doc"
    "--without-glibmm-doc"
    "--without-cairomm-doc"
  ];

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    cairomm
    glibmm
    pango
  ];

  buildInputs = [
    cairo
    libpng
  ];

  postInstall = ''
    # pangomm use C++11 features in headers, programs linking against pangomm
    # will also need C++11 enabled.
    sed -e 's,Cflags:,Cflags: -std=c++11,' -i $out/lib/pkgconfig/*.pc
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ interface to the Pango text rendering library";
    homepage = http://www.pango.org/;
    license = with licenses; [ lgpl2 lgpl21 ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
