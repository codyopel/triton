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

  # Because there are a number of needed commits (patches) on the gtk+ 2.24
  # branch, which also require running autoreconf, and the tarballs are missing
  # files to do so.
  src = fetchFromGitHub {
    owner = "gnome";
    repo = "gtk";
    # Use the latest commit from the 2.24 branch of the upstream git repository.
    rev = "3b65a6a42ed2d4d2ecdcec94163ce0b748e707fc";
    sha256 = "112w10ywjcx6w4w0g19fsn9lj5xgpzzb6msms1b8vslbz142j8ji";
  };

  postPatch =
    optionalString (!tests) ''
      # Don't build tests if disabled
      sed -e 's|demos tests perf|demos perf|' -i ./Makefile.*
      sed -e 's|$(gdktarget) . tests|$(gdktarget) .|' -i ./gdk/Makefile.*
    '';

  configureFlags = [
    (enFlag "shm" (xorg.libXext != null) null)
    (enFlag "xkb" (libxkbcommon != null) null)
    (enFlag "xinerama" (xorg.libXinerama != null) null)
    "--enable-rebuilds"
    "--enable-visibility"
    (enFlag "glibtest" tests null)
    "--enable-modules"
    "--disable-quartz-relocation"
    (enFlag "cups" (cups != null) null)
    (enFlag "papi" false null)
    (enFlag "test-print-backend" tests null)
    (enFlag "introspection" (gobjectIntrospection != null) "yes")
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-man"
    (wtFlag "xinput" (xorg.libXi != null) "yes")
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
    fontconfig
    gobjectIntrospection
    libintlOrEmpty
    libxkbcommon
    xorg.inputproto
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
  ];

  propagatedBuildInputs = [
    atk # pkgconfig
    cairo # pkgconfig
    gdk_pixbuf # pkgconfig
    glib # pkgconfig
    pango # pkgconfig
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  passthru = {
    gtkExeEnvPostBuild = ''
      rm $out/lib/gtk-2.0/2.10.0/immodules.cache
      $out/bin/gtk-query-immodules-2.0 $out/lib/gtk-2.0/2.10.0/immodules/*.so > $out/lib/gtk-2.0/2.10.0/immodules.cache
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
