{ stdenv, fetchurl
, pkgconfig

, atk
, glibmm
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

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  configureFlags = [
    "--enable-deprecated-api"
    "--disable-documentation"
    "--without-libstdc-doc"
    "--without-libsigc-doc"
    "--without-glibmm-doc"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    atk
    glibmm
  ];

  postInstall = ''
    # atkmm use C++11 features in headers, programs linking against atkmm
    # will also need C++11 enabled.
    sed -e 's,Cflags:,Cflags: -std=c++11,' -i $out/lib/pkgconfig/*.pc
  '';

  enableParallelBuilding = true;
}