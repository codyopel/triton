{ stdenv, fetchurl
, bison
, flex
, gettext
, perl
, pkgconfig
, python

, glib
, gobjectIntrospection
, libcap
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.6.2";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/gstreamer/${name}.tar.xz";
    sha256 = "1cpyz3x1yzqmbmircjpnizawkxmn5gzjwalkaajdp2g0v1mp35jq";
  };

  setupHook = ./setup-hook-1.0.sh;

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-rpath"
    "--disable-fatal-warnings"
    "--disable-gst-debug"
    "--enable-parse"
    "--enable-option-parsing"
    "--disable-trace"
    "--disable-alloc-trace"
    "--enable-registry"
    "--enable-plugin"
    "--disable-debug"
    "--disable-profiling"
    "--disable-valgrind"
    "--disable-gcov"
    "--disable-examples"
    "--disable-static-plugins"
    "--disable-tests"
    "--disable-failing-tests"
    "--disable-benchmarks"
    "--enable-tools"
    "--disable-poisoning"
    "--enable-largefile"
    "--enable-introspection"
    "--disable-docbook"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-gobject-cast-checks"
    "--enable-glib-asserts"
    "--disable-check"
    "--enable-Bsymbolic"
  ];

  nativeBuildInputs = [
    bison
    flex
    gettext
    perl
    pkgconfig
    python
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    gobjectIntrospection
    libcap
  ];

  preFixup = ''
    # Needed for orc-using gst plugins on hardened/PaX systems
    paxmark m \
      $out/bin/gst-launch* \
      $out/libexec/gstreamer-0.10/gst-plugin-scanner
  '';

  meta = with stdenv.lib; {
    description = "Multimedia framework";
    homepage = http://gstreamer.freedesktop.org;
    license = licenses.lgpl2plus;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
