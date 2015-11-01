{ fetchurl, stdenv
, pkgconfig
, clutter
, gtk3
, glib
, cogl
, gst_all_1
}:

stdenv.mkDerivation rec {
  name = "clutter-gst-${version}";
  versionMajor = "3.0";
  versionMinor = "10";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/${versionMajor}/${name}.tar.xz";
    sha256 = "130l8bpggqnyvwas8yad1s0zb0dpyrhlqsgivfxq89p9j8rbrg9d";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    clutter
    gtk3
    glib
    cogl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  postBuild = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GStreamer bindings for clutter";
    homepage = http://www.clutter-project.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.gnu;
  };
}
