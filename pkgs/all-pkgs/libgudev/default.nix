{ stdenv, fetchurl
, pkgconfig

, glib
, gobjectIntrospection
, udev
}:

stdenv.mkDerivation rec {
  name = "libgudev-${version}";
  version = "230";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgudev/${version}/${name}.tar.xz";
    sha256 = "063w6j35n0i0ssmv58kivc1mw4070z6fzb83hi4xfrhcxnn7zrx2";
  };

  configureFlags = [
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-introspection"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    glib
    gobjectIntrospection
    udev
  ];

  meta = with stdenv.lib; {
    description = "GObject bindings for udev";
    homepage = https://wiki.gnome.org/Projects/libgudev;
    license = licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
