{ stdenv, fetchurl
, pkgconfig

, gstreamer
, gst-plugins-base
, ncurses
, python3
, python3Packages
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.6.2";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/gst-python/${name}.tar.xz";
    sha256 = "09ci5zvr7lms7mvgbjgsjwaxcl4nq45n1g9pdwnqmx3rf0qkwxjf";
  };

  patches = [
    ./gst-python-1.0-different-path-with-pygobject.patch
  ];

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-valgrind"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    python3
    python3Packages.pygobject
  ];

  buildInputs = [
    gstreamer
    ncurses
  ];

  meta = with stdenv.lib; {
    description = "A Python Interface to GStreamer";
    homepage = http://gstreamer.freedesktop.org;
    license = licenses.lgpl2;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
