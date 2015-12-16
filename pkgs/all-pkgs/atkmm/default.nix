{ stdenv, fetchurl
, pkgconfig

, atk
, glibmm
}:

stdenv.mkDerivation rec {
  name = "atkmm-${version}";
  versionMajor = "2.24";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/atkmm/${versionMajor}/${name}.tar.xz";
    sha256 = "1gaqwhviadsmy0fsr47686yglv1p4mpkamj0in127bz2b5bki5gz";
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