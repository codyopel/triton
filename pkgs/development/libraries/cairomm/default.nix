{ fetchurl, stdenv
, pkgconfig

, cairo
, fontconfig
, freetype
, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "cairomm-1.12.0";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "1k3lb3jwnk5nm4s5cfm5kk8kl4b066chis4inws6k5yxdzn5lhsh";
  };

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  configureFlags = [
    "--disable-documentation"
    "--disable-tests"
    "--enable-api-exceptions"
    "--without-libstdc-doc"
    "--without-libsigc-doc"
    "--without-boost"
    "--without-boost-unit-test-framework"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    cairo
    libsigcxx
  ];

  postInstall = ''
    # cairomm use C++11 features in headers, programs linking against cairomm
    # will also need C++11 enabled.
    sed -e 's,Cflags:,Cflags: -std=c++11,' -i $out/lib/pkgconfig/*.pc
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 2D graphics library with support for multiple output devices";
    homepage = http://cairographics.org/;
    license = with licenses; [ lgpl2Plus mpl10 ];
  };
}
