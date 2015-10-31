{ stdenv, fetchurl
, pkgconfig
, gnum4
}:

stdenv.mkDerivation rec {
  name = "libsigc++-${version}";
  versionMajor = "2.6";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${versionMajor}/${name}.tar.xz";
    sha256 = "06xyvxaaxh3nbpjg86gcq5zcc2qnpx354wcfrqlhbndkq5kj2vqq";
  };

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  nativeBuildInputs = [
    pkgconfig
    gnum4
  ];

  doCheck = true;

  meta = {
    description = "A typesafe callback system for standard C++";
    homepage = http://libsigc.sourceforge.net/;
  };
}
