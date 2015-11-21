{ stdenv, fetchurl
, gobjectIntrospection
, intltool
, pkgconfig

, glib
, gnome3
, gtk3
, libxml2
, ncurses
, pango
, zlib
, selectTextPatch ? false
}:

with {
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "vte-${version}";
  versionMajor = "0.36";
  versionMinor = "5";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/${versionMajor}/${name}.tar.xz";
    sha256 = "1psfnqsmxx4qzc55qwvb8jai824ix4pqcdqhgxk0g2zh82bcxhn2";
  };

  postPatch = ''
    patchShebangs src/test-vte-sh.sh
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-debug"
    "--enable-nls"
    "--enable-Bsymbolic"
    "--enable-gnome-pty-helper"
    "--disable-glade"
    "--enable-introspection"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
  ];

  nativeBuildInputs = [
    gobjectIntrospection
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    pango
    zlib
  ];

  buildInputs = [
    libxml2
    ncurses
  ];

  postInstall = ''
    substituteInPlace $out/lib/libvte2_90.la \
      --replace "-lncurses" "-L${ncurses}/lib -lncurses"
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library implementing a terminal emulator widget for GTK+";
    homepage = http://www.gnome.org/;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
