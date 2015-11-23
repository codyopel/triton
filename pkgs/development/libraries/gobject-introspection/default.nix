{ stdenv, fetchurl
, bison
, flex
, pkgconfig

, glib
, libffi
, python
# Tests
, cairo
}:

with {
  inherit (stdenv.lib)
    optionals
    wtFlag;
};

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

  postPatch = ''
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
    "--without-cairo"
    (wtFlag "cairo" doCheck null)
    "--with-python=${python.interpreter}"
  ];

  buildInputs = [
    bison
    flex
    pkgconfig
    python
  ] ++ optionals doCheck [
    cairo
  ];

  propagatedBuildInputs = [
    glib
    libffi
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage = http://live.gnome.org/GObjectIntrospection;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
