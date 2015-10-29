{ stdenv, fetchurl
, pkgconfig
, gnum4
}:

stdenv.mkDerivation rec {
  name = "libsigc++-${version}";
  versionMajor = "2.4";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${versionMajor}/${name}.tar.xz";
    sha256 = "1v0rvkzglzmf67y9nkcppwjwi68j1cy5yhldvcq7xrv8594l612l";
  };

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
