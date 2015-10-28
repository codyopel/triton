{ stdenv, fetchurl
, autoreconfHook
, gettext
, intltool
, pkgconfig

, exiv2
, gdk_pixbuf
, glib
, gtk2
, lcms
, libpng
, shared_mime_info
}:

stdenv.mkDerivation rec {
  name = "viewnior-${version}";
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/xsisqox/Viewnior/archive/viewnior-${version}.tar.gz";
    sha256 = "10by9zpasl79j234mciwa0x7fqvhxl6r3q31cnpk8sq96fi589bz";
  };

  configureFlags = [
    "--enable-wallpaper"
  ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    intltool
    pkgconfig
  ];

  buildInputs = [
    exiv2
    gdk_pixbuf
    glib
    gtk2
    lcms
    libpng
    shared_mime_info
  ];

  preFixup = ''
    rm $out/share/icons/*/icon-theme.cache
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fast and simple image viewer";
    homepage = http://siyanpanayotov.com/project/viewnior/;
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
