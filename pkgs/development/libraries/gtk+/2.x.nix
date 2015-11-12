{ stdenv, fetchFromGitHub
, autoconf
, automake
, gettext
, gtk_doc
, intltool
, libtool
, perl
, pkgconfig

, atk
, cairo
, cups
, fontconfig
, gdk_pixbuf
, glib
, gobjectIntrospection
, libintlOrEmpty
, libxkbcommon
, pango
, xlibsWrapper
, xorg
, libxcb
, tests ? false
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag
    optionalString;
};

stdenv.mkDerivation rec {
  name = "gtk+-${version}";
  versionMajor = "2.24";
  versionMinor = "28";
  version = "${versionMajor}.${versionMinor}";

  src = fetchFromGitHub {
    owner = "gnome";
    repo = "gtk";
    # Use the latest commit from the 2.24 branch of the upstream git repository.
    rev = "3b65a6a42ed2d4d2ecdcec94163ce0b748e707fc";
    sha256 = "112w10ywjcx6w4w0g19fsn9lj5xgpzzb6msms1b8vslbz142j8ji";
  };

  configureFlags = [
    (enFlag "shm" (xorg.libXext != null) null)
    (enFlag "xkb" (libxkbcommon != null) null)
    (enFlag "xinerama" (xorg.libXinerama != null) null)
    "--enable-rebuilds"
    "--enable-visibility"
    "--enable-explicit-deps"
    "--enable-glibtest"
    "--enable-modules"
    "--disable-quartz-relocation"
    (enFlag "cups" (cups != null) null)
    (enFlag "papi" false null)
    (enFlag "test-print-backend" (cups != null) null)
    (enFlag "introspection" (gobjectIntrospection != null) null)
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-man"
    (wtFlag "xinput" (xorg.libXi != null) null)
    (wtFlag "gdktarget" (true) "x11") # add xorg deps
    #"--with-gdktarget=directfb"
    (wtFlag "x" (xorg != null) null)
  ];

  NIX_CFLAGS_COMPILE = optionalString (libintlOrEmpty != []) "-lintl";

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    gtk_doc
    intltool
    libtool
    perl
    pkgconfig
  ];

  buildInputs = [
    cups
    gobjectIntrospection
    libxkbcommon
    xorg.inputproto
  ] ++ libintlOrEmpty;

  propagatedBuildInputs = [
    atk # pkgconfig
    cairo # pkgconfig
    fontconfig
    gdk_pixbuf # pkgconfig
    glib # pkgconfig
    pango # pkgconfig
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  passthru = {
    gtkExeEnvPostBuild = ''
      rm -v $out/lib/gtk-2.0/2.10.0/immodules.cache
      $out/bin/gtk-query-immodules-2.0 \
        $out/lib/gtk-2.0/2.10.0/immodules/*.so > \
        $out/lib/gtk-2.0/2.10.0/immodules.cache
    ''; # workaround for bug of nix-mode for Emacs */ '';
  };

  meta = with stdenv.lib; {
    description = "A toolkit for creating graphical user interfaces";
    homepage = http://www.gtk.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
