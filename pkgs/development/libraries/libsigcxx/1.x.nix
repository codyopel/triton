{ stdenv, fetchurl
, pkgconfig
, gnum4
}:

stdenv.mkDerivation rec {
  name = "libsigc++-${version}";
  versionMajor = "1.2";
  versionMinor = "7";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${versionMajor}/${name}.tar.gz";
    sha256 = "166bvyxma52245rdnypl2f1hz3p62dx30qkxiiflawcz7mia95f9";
  };

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
