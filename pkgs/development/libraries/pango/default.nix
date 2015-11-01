{ stdenv, fetchurl
, pkgconfig

, cairo
, fontconfig
, freetype
, glib
, gobjectIntrospection
, harfbuzz
, libintlOrEmpty
, libpng
, xlibsWrapper
}:

stdenv.mkDerivation rec {
  name = "pango-${version}";
  versionMajor = "1.38";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${versionMajor}/${name}.tar.xz";
    sha256 = "1dsf45m51i4rcyvh5wlxxrjfhvn5b67d5ckjc6vdcxbddjgmc80k";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    cairo
    fontconfig
    freetype
    glib
  ];

  buildInputs = [
    gobjectIntrospection
    xlibsWrapper
    libpng
    harfbuzz
    libintlOrEmpty
  ];

  enableParallelBuilding = true;
  doCheck = false;

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    description = "A library for laying out and rendering of text";
    homepage = http://www.pango.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
