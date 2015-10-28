{ stdenv, fetchurl
, gettext
, intltool
, pkgconfig

, parted
, gtk2
, glib
, libuuid
, gtkmm
, libxml2
, hicolor_icon_theme
}:

stdenv.mkDerivation rec {
  name = "gparted-0.24.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
    sha256 = "0q6d1s9f4qgdivj4vm9w87qmdfyq8s65jzkhv05rp9cl72rqlf82";
  };

  configureFlags = [
    "--disable-doc"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];

  buildInputs = [
    parted
    gtk2
    glib
    libuuid
    gtkmm
    libxml2
    hicolor_icon_theme
  ];

  meta = with stdenv.lib; {
    description = "Graphical disk partitioning tool";
    homepage = http://gparted.org;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
