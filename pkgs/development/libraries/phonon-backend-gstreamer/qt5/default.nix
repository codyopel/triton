{ stdenv, fetchurl
, cmake
, pkgconfig

, gst_all_1
, phonon
, qtbase
, debug ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "phonon-backend-gstreamer-${version}";
  version = "4.8.2";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/phonon-backend-gstreamer/${version}/src/${name}.tar.xz";
    sha256 = "1q1ix6zsfnh6gfnpmwp67s376m7g7ahpjl1qp2fqakzb5cgzgq10";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DPHONON_BUILD_PHONON4QT5=ON"
  ] ++ optional debug "-DCMAKE_BUILD_TYPE=Debug";

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    phonon
    qtbase
  ];

  meta = with stdenv.lib; {
    description = "GStreamer backend for Phonon";
    homepage = http://phonon.kde.org/;
    maintainer = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
