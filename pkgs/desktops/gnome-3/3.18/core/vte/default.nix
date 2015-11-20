{ stdenv, fetchurl
, intltool
, pkgconfig

, glib
, gnome3
, gobjectIntrospection
, gnutls
, gtk3
, libxml2
, ncurses
, pango
, pcre2
, vala
, zlib
, selectTextPatch ? false
}:

with {
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "vte-${version}";
  versionMajor = "0.43";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/${versionMajor}/${name}.tar.xz";
    sha256 = "1faa9n6dn0vgzlbf9vlm7d0ksw19577p57v3b3j9wgk3910sw41g";
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
    # test application uses deprecated functions
    "--disable-test-application"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--with-gnutls"
    "--with-pcre2"
  ];

  nativeBuildInputs = [
    gobjectIntrospection
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
    gnutls
    gtk3
    pango
    pcre2
    zlib
  ];

  buildInputs = [
    libxml2
    ncurses
    vala
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
