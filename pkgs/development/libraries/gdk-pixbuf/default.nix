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
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${versionMajor}/${name}.tar.xz";
    sha256 = "1g7kjxv67jcdasi14n7jan4icrnnppd1m99wrdmpv32k4m7vfcj4";
  };

  setupHook = ./setup-hook.sh;

  configureFlags = [
    "--with-libjasper"
    "--with-x11"
    "--enable-introspection=yes"
  ];

  nativeBuildInputs = [
    gobjectIntrospection
    libintlOrEmpty
    pkgconfig
  ];

  buildInputs = [
    glib
    jasper
    libjpeg
    libpng
    libtiff
    libX11
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
