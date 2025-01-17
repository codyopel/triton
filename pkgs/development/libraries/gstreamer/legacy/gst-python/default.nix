{ fetchurl, stdenv, pkgconfig, python, gstreamer
, gst_plugins_base, pygobject, pygtk
}:

stdenv.mkDerivation rec {
  name = "gst-python-0.10.22";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.bz2"
      "mirror://gentoo/${name}.tar.bz2"
      ];
    sha256 = "0y1i4n5m1diljqr9dsq12anwazrhbs70jziich47gkdwllcza9lg";
  };

  # Need to disable the testFake test case due to bug in pygobject.
  # See https://bugzilla.gnome.org/show_bug.cgi?id=692479
  patches = [ ./disable-testFake.patch ];

  buildInputs =
    [ pkgconfig gst_plugins_base pygobject pygtk ]
    ;

  propagatedBuildInputs = [ gstreamer python ];

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
