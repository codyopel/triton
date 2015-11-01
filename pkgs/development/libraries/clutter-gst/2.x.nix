{ fetchurl, stdenv
, pkgconfig
, clutter
, gtk3
, glib
, cogl
, gstreamer
, gst_plugins_base
}:

stdenv.mkDerivation rec {
  name = "clutter-gst-${version}";
  versionMajor = "2.0";
  versionMinor = "16";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/${versionMajor}/${name}.tar.xz";
    sha256 = "0f90fkywwn9ww6a8kfjiy4xx65b09yaj771jlsmj2w4khr0zhi59";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    clutter
    gtk3
    glib
    cogl
    gstreamer
    gst_plugins_base
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
