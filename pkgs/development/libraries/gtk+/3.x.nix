{ stdenv, fetchurl
, pkgconfig
, gettext
, perl
, gobjectIntrospection

, at_spi2_atk
, atk
, cairo
, cups
, epoxy
, expat
, fontconfig
, gdk_pixbuf
, glib
, libxkbcommon
, pango
, wayland
, xlibsWrapper
, xorg
, gnome3
, mesa_noglu
}:

stdenv.mkDerivation rec {
  name = "gtk+-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${versionMajor}/${name}.tar.xz";
    sha256 = "0lp1hn0qydxx03bianzzr0a4maqzsvylrkzr7c3p0050qihwbgjx";
  };

  # demos fail to install, no idea where the problem is
  preConfigure = "sed '/^SRC_SUBDIRS /s/demos//' -i Makefile.in";

  configureFlags = [
    "--enable-x11-backend"
    "--enable-wayland-backend"
  ];

  nativeBuildInputs = [
    gettext
    gobjectIntrospection
    perl
    pkgconfig
  ];

  buildInputs = [
    at_spi2_atk
    cairo
    cups
    epoxy
    expat
    fontconfig
    glib
    libxkbcommon
    mesa_noglu
    wayland
    xorg.inputproto
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
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
      rm $out/lib/gtk-3.0/3.0.0/immodules.cache
      $out/bin/gtk-query-immodules-3.0 $out/lib/gtk-3.0/3.0.0/immodules/*.so > $out/lib/gtk-3.0/3.0.0/immodules.cache
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
