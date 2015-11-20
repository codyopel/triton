{ stdenv, fetchurl
, bison
, flex
, libtool
, pkgconfig

, cairo
, glib
, libffi
, libintlOrEmpty
, python
}:

stdenv.mkDerivation rec {
  name = "gobject-introspection-${versionMajor}.${versionMinor}";
  versionMajor = "1.46";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/${versionMajor}/${name}.tar.xz";
    sha256 = "0cs27r18fga44ypp8icy62fwx6nh70r1bvhi4lzfn4w85cybsn36";
  };

  setupHook = ./setup-hook.sh;

  patches = [
    ./absolute_shlib_path.patch
  ];

  patchPhase = ''
    patchShebangs tests/gi-tester

    # patchShebangs does not catch @PYTHON@
    sed -e 's|#!/usr/bin/env @PYTHON@|#!${python.interpreter}|' \
        -i tools/g-ir-tool-template.in
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-doctool"
    "--enable-Bsymbolic"
    "--with-cairo"
    "--with-python=${python.interpreter}"
  ];

  buildInputs = [
    bison
    cairo
    flex
    libtool
    pkgconfig
    python
  ] ++ libintlOrEmpty;

  propagatedBuildInputs = [
    glib
    libffi
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage = http://live.gnome.org/GObjectIntrospection;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
