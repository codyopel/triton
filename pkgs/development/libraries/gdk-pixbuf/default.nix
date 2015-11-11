{ stdenv, fetchurl
, pkgconfig
, glib
, libtiff
, libjpeg
, libpng
, libX11
, jasper
, libintlOrEmpty
, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-${version}";
  versionMajor = "2.32";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${versionMajor}/${name}.tar.xz";
    sha256 = "0ib1jap60xkv74ndha06y8ziglpspp77fz62skzfy4rv2by0dayk";
  };

  setupHook = ./setup-hook.sh;

  configureFlags = [
    "--enable-gio-sniffing"
    "--enable-rebuilds"
    "--enable-nls"
    "--enable-rpath"
    "--enable-glibtest"
    "--enable-modules"
    "--enable-introspection"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-man"
    "--enable-Bsymbolic"
    "--disable-installed-tests"
    "--disable-always-build-tests"
    "--disable-coverage"
    "--enable-relocations"
    "--with-libpng"
    "--with-libjpeg"
    "--with-libjasper"
    "--without-gdiplus"
    "--with-x11"
  ];

  nativeBuildInputs = [
    gobjectIntrospection
    pkgconfig
  ] ++ libintlOrEmpty;

  buildInputs = [
    glib
    jasper
    libjpeg
    libpng
    libtiff
    libX11
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
