{ stdenv, fetchurl, pkgconfig, gst_plugins_base, gstreamer }:

stdenv.mkDerivation rec {
  name = "gnonlin-0.10.17";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gnonlin/${name}.tar.bz2"
      "mirror://gentoo/${name}.tar.bz2"
      ];
    sha256 = "0dc9kvr6i7sh91cyhzlbx2bchwg84rfa4679ccppzjf0y65dv8p4";
  };

  buildInputs = [ gst_plugins_base gstreamer pkgconfig ];

  meta = {
    homepage = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
    description = "Gstreamer Non-Linear Multimedia Editing Plugins";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
