{ stdenv, fetchurl
, intltool
, pkgconfig

, gnome3
, ncurses
, gobjectIntrospection
, vala
, libxml2
, gnutls
, selectTextPatch ? false
}:

with {
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "vte-${version}";
  versionMajor = "0.42";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/${versionMajor}/${name}.tar.xz";
    sha256 = "0d4xzjq6mxrlhnh4i12a1yy90n41m03z8wf8g6wh4hjgx7ly404y";
  };

  patches = optional selectTextPatch ./expose_select_text.0.40.0.patch;

  postPatch = "patchShebangs .";

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-debug"
    "--enable-nls"
    "--enable-Bsymbolic"
    "--disable-glade"
    "--enable-introspection"
    "--enable-vala"
    "--disable-test-application"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--with-gnutls"
  ];

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    gnutls
  ];

  buildInputs = [
    gobjectIntrospection
    gnome3.glib
    gnome3.gtk3
    ncurses
    vala
    libxml2
  ];

  postInstall = ''
    substituteInPlace $out/lib/libvte2_90.la \
      --replace "-lncurses" "-L${ncurses}/lib -lncurses"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library implementing a terminal emulator widget for GTK+";
    homepage = http://www.gnome.org/;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
