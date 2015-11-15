{ stdenv, fetchurl
, pkgconfig
, gnum4
}:

stdenv.mkDerivation rec {
  name = "libsigc++-${version}";
  versionMajor = "2.6";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${versionMajor}/${name}.tar.xz";
    sha256 = "0ds4wlys149gi320xiy452dr0mq6r94r03sp2wn7kpii9h9ygb7x";
  };

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  nativeBuildInputs = [
    pkgconfig
    gnum4
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = {
    description = "A typesafe callback system for standard C++";
    homepage = http://libsigc.sourceforge.net/;
  };
}
