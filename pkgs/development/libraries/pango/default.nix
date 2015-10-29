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
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${versionMajor}/${name}.tar.xz";
    sha256 = "0v12gi7f01iq3z852pclpnmkbcksbvpcmiazmklkx1dd9fbpakhx";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    cairo
    fontconfig
    freetype
  ];

  buildInputs = [
    gobjectIntrospection
    xlibsWrapper
    glib
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
