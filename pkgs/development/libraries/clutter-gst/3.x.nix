{ fetchurl, stdenv
, pkgconfig

, clutter
, cogl
, glib
, gobjectIntrospection
, gtk3
, gst_all_1
}:

stdenv.mkDerivation rec {
  name = "clutter-gst-${version}";
  versionMajor = "3.0";
  versionMinor = "14";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/${versionMajor}/${name}.tar.xz";
    sha256 = "1qidm0q28q6w8gjd0gpqnk8fzqxv39dcp0vlzzawlncp8zfagj7p";
  };

  configureFlags = [
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-introspection"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    clutter
    cogl
    glib
    gobjectIntrospection
    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  postBuild = "rm -rvf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GStreamer bindings for clutter";
    homepage = http://www.clutter-project.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.gnu;
  };
}
