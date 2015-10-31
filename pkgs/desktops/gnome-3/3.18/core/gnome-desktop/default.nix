{ stdenv, fetchurl
, pkgconfig
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

  # this should probably be setuphook for glib
  NIX_CFLAGS_COMPILE = [
    "-I${glib}/include/gio-unix-2.0"
  ];

  buildInputs = [
    pkgconfig
    python
    libxml2Python
    libxslt
    which
    libX11
    xkeyboard_config
    isocodes
    itstool
    wayland
    gtk3
    glib
    intltool
    gnome_doc_utils
    libxkbfile
    gobjectIntrospection
    xorg.libXext
    xorg.libXrandr
  ];

  propagatedBuildInputs = [
    gnome3.gsettings_desktop_schemas
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}