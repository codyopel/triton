{ stdenv, fetchurl
, atk
, glibmm
, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "atkmm-${version}";
  versionMajor = "2.24";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/atkmm/${versionMajor}/${name}.tar.xz";
    sha256 = "08zd6s5c1q90wm8310mdrb5f2lj8v63wxihrybwyw13xlf6ivi16";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    atk
  ];

  propagatedBuildInputs = [
    glibmm
  ];

  enableParallelBuilding = true;
}