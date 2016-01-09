{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gst--1.6.0";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/gst-/${name}.tar.xz";
    sha256 = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
  };

  configureFlags = [

  ];

  nativeBuildInputs = [

  ];

  buildInputs = [

  ];

  meta = with stdenv.lib; {
    description = "";
    homepage = http://gstreamer.freedesktop.org;
    license = licenses.;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
