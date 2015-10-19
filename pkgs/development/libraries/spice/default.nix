{ stdenv, fetchurl
, pkgconfig
, spice_protocol

, pixman
, celt
, alsaLib
, openssl
, libXrandr
, libXfixes
, libXext
, libXrender
, libXinerama
, libjpeg
, zlib
, python
, pyparsing
, glib
, cyrus_sasl
, lz4
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "spice-0.12.6";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "1dk9hp78ldqb0a52kdlqq0scnk3drnhj7rsw8r7hmy2v2cqflj7i";
  };

  configureFlags = [
    "--with-sasl"
    "--disable-smartcard"
    "--enable-client"
    "--enable-lz4"
  ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  nativeBuildInputs = [
    pkgconfig
    spice_protocol
  ];

  buildInputs = [
    pixman
    celt
    alsaLib
    openssl
    libjpeg
    zlib
    libXrandr
    libXfixes
    libXrender
    libXext
    libXinerama
    python
    pyparsing
    glib
    cyrus_sasl
    lz4
  ];

  postInstall = ''
    ln -s spice-server $out/include/spice
  '';

  meta = {
    description = "Solution for interaction with virtualized desktop devices";
    homepage = http://www.spice-space.org/;
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
