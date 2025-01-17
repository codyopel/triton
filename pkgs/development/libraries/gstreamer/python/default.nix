{ fetchurl, stdenv, pkgconfig, python
, gst-plugins-base, pygobject
, ncurses
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.4.0";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0gixsp46mv7fvhk669q60wfk9w2lc02sdb1qipq066xlrqlhrr5i";
  };

  patches = [ ./different-path-with-pygobject.patch ];

  nativeBuildInputs = [ pkgconfig python ];

  # XXX: in the Libs.private field of python3.pc
  buildInputs = [ ncurses ];

  preConfigure = ''
    export configureFlags="$configureFlags --with-pygi-overrides-dir=$out/lib/${python.libPrefix}/site-packages/gi/overrides"
  '';

  propagatedBuildInputs = [ gst-plugins-base pygobject ];

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
