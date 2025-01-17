{ stdenv, fetchurl
, gettext
, gobjectIntrospection
, perl
, pkgconfig

, at_spi2_atk
, atk
, cairo
, colord
, cups
, epoxy
, expat
, fontconfig
, gdk_pixbuf
, glib
, gnome3
, gtk3Wrapper
, json_glib
, librsvg
, libxkbcommon
, mesa_noglu
, pango
, shared_mime_info
, wayland
, xlibsWrapper
, xorg

, tests ? false
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag;
};

stdenv.mkDerivation rec {
  name = "gtk+-${version}";
  versionMajor = "3.18";
  versionMinor = "6";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${versionMajor}/${name}.tar.xz";
    sha256 = "1vs1whvsmpn3r5a08w0xgianrivj61isrmb27xrghqm6sl7vzjkq";
  };

  # demos fail to install, no idea where the problem is
  postPatch = "sed '/^SRC_SUBDIRS /s/demos//' -i Makefile.in";

  configureFlags = [
    (enFlag "xkb" (libxkbcommon != null) null)
    (enFlag "xinerama" (xorg.libXinerama != null) null)
    (enFlag "xrandr" (xorg.libXrandr != null) null)
    (enFlag "xfixes" (xorg.libXfixes != null) null)
    (enFlag "xcomposite" (xorg.libXcomposite != null) null)
    (enFlag "xdamage" (xorg.libXdamage != null) null)
    (enFlag "x11-backend" (true) null) # xorg deps
    "--disable-win32-backend"
    "--disable-quartz-backend"
    (enFlag "broadway-backend" true null)
    (enFlag "wayland-backend" (wayland != null) null)
    "--disable-mir-backend"
    "--disable-quartz-relocation"
    #"--enable-explicit-deps"
    "--enable-glibtest"
    #"--enable-modules"
    (enFlag "cups" (cups != null) null)
    "--disable-papi"
    (enFlag "cloudprint" (gnome3.rest != null && json_glib != null) null)
    (enFlag "test-print-backend" (cups != null) null)
    "--enable-schemas-compile"
    (enFlag "introspection" (gobjectIntrospection != null) null)
    (enFlag "colord" (colord != null) null)
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-man"
    "--disable-doc-cross-references"
    "--enable-Bsymbolic"
    (wtFlag "x" (xorg != null) null)
  ];

  nativeBuildInputs = [
    gettext
    gobjectIntrospection
    perl
    pkgconfig
  ];

  propagatedBuildInputs = [
    atk # pkgconfig
    cairo # pkgconfig
    gdk_pixbuf # pkgconfig
    glib # pkgconfig
    gnome3.adwaita-icon-theme
    gtk3Wrapper
    pango # pkgconfig
    xorg.libICE
    xorg.libSM
  ];

  buildInputs = [
    at_spi2_atk
    colord
    cups
    epoxy
    expat
    fontconfig
    gnome3.rest
    json_glib
    librsvg
    libxkbcommon
    mesa_noglu
    shared_mime_info
    wayland
    xorg.inputproto
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  # TODO: disable unnecessary tests
  doCheck = false;
  enableParallelBuilding = true;

  passthru = {
    gtkExeEnvPostBuild = ''
      rm $out/lib/gtk-3.0/3.0.0/immodules.cache
      $out/bin/gtk-query-immodules-3.0 $out/lib/gtk-3.0/3.0.0/immodules/*.so > \
        $out/lib/gtk-3.0/3.0.0/immodules.cache
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
