{ stdenv, fetchurl
, coreutils
, gettext
, gobjectIntrospection
, libintlOrEmpty
, pkgconfig

, glib
, libtiff
, libjpeg
, libpng
, libX11
, jasper
}:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-${version}";
  versionMajor = "2.33";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${versionMajor}/${name}.tar.xz";
    sha256 = "12q8nlrh8svf3msj2k69pi21zjpxdlh1872py0p4w86qkfrmh8qk";
  };

  setupHook = ./setup-hook.sh;

  configureFlags = [
    "--disable-gio-sniffing"
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
    "--enable-installed-tests"
    "--enable-always-build-tests"
    "--disable-coverage"
    # Enabling relocations breaks setting loaders.cache path
    "--disable-relocations"
    "--with-libpng"
    "--with-libjpeg"
    "--with-libjasper"
    "--with-gdiplus"
    "--with-x11"
  ];

  nativeBuildInputs = [
    coreutils
    gettext
    gobjectIntrospection
    pkgconfig
  ] ++ libintlOrEmpty;

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    jasper
    libjpeg
    libpng
    libtiff
    libX11
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
