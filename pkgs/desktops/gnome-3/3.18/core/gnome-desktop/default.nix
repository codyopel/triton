{ stdenv, fetchurl
, pkgconfig
, gettext

, python
, libxml2Python
, libxslt
, which
, libX11
, gnome3
, gtk3
, glib
, intltool
, gnome_doc_utils
, libxkbfile
, xkeyboard_config
, isocodes
, itstool
, wayland
, gobjectIntrospection
, xorg
}:

stdenv.mkDerivation rec {
  name = "gnome-desktop-${majorVersion}.${minorVersion}";
  majorVersion = gnome3.version;
  minorVersion = "1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${majorVersion}/${name}.tar.xz";
    sha256 = "0avpmyhzz5b3pyfpkp8iq5ym5r5w7zs3a396hqkdpdsiym0vrazc";
  };

  configureFlags = [
    "--enable-nls"
    "--disable-date-in-gnome-version"
    "--enable-compile-warnings"
    "--enable-introspection"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--with-x"
  ];

  NIX_CFLAGS_COMPILE = [
    # this should probably be setuphook for glib
    "-I${glib}/include/gio-unix-2.0"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
    libxslt
    which
    intltool
  ];

  buildInputs = [
    glib
    gnome_doc_utils
    gobjectIntrospection
    isocodes
    itstool
    libxkbfile
    libxml2Python
    python
    wayland
    xkeyboard_config
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.xproto
    xorg.randrproto
  ];

  propagatedBuildInputs = [
    gnome3.gsettings_desktop_schemas
    gtk3
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}