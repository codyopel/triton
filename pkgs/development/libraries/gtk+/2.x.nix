{ stdenv, fetchurl
, gettext
, perl
, pkgconfig

, atk
, cairo
, cups
, fontconfig
, gdk_pixbuf
, glib
#, gobjectIntrospection
, libintlOrEmpty
, libxkbcommon
, pango
, xlibsWrapper
, xorg
}:

let
  inherit (stdenv.lib)
    optionalString;
in

stdenv.mkDerivation rec {
  name = "gtk+-${version}";
  versionMajor = "2.24";
  versionMinor = "28";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${versionMajor}/${name}.tar.xz";
    sha256 = "0mj6xn40py9r9lvzg633fal81xfwfm89d9mvz7jk4lmwk0g49imj";
  };

  patchPhase = ''
    # marshalers code was pre-generated with glib-2.31
    # https://bugzilla.gnome.org/show_bug.cgi?id=662109
    rm -v \
      gdk/gdkmarshalers.c \
      gtk/gtkmarshal.c \
      gtk/gtkmarshalers.c \
      perf/marshalers.c
  '';

  configureFlags = [
    "--enable-xkb"
    "--enable-xinerama"
    "--with-xinput=yes"
    "--enable-cups"
    #"--enable-papi"
    "--enable-man"
  ];

  NIX_CFLAGS_COMPILE = optionalString (libintlOrEmpty != []) "-lintl";

  nativeBuildInputs = [
    gettext
    perl
    pkgconfig
  ];

  buildInputs = [
    cairo
    cups
    fontconfig
    glib
    libintlOrEmpty
    libxkbcommon
    xorg.inputproto
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
  ];

  propagatedBuildInputs = [
    atk
    gdk_pixbuf
    pango
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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
