{ stdenv, fetchurl, fetchpatch
, pkgconfig
, libiconv
, libintlOrEmpty
, zlib
, curl
, cairo
, freetype
, fontconfig
, libtiff
, lcms2
, libjpeg
, libpng
, openjpeg
# QT4
, qt4 ? null
# QT5
, qt5 ? null
, utils ? false
, suffix ? "glib"
, glib
, gobjectIntrospection
}:

with {
  inherit (stdenv.lib)
    enFlag
    optional
    optionals
    wtFlag;
};

assert (
  suffix == "glib" ||
  suffix == "qt4" ||
  suffix == "qt5" ||
  suffix == "utils"
);

stdenv.mkDerivation rec {
  name = "poppler-${suffix}-${version}";
  version = "0.38.0";

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    sha256 = "12wa9r2nxb2ajj4wvj9mbldr1k0rgx714j33zq67qv9lr14hs33g";
  };

  patches = [
    ./datadir_env.patch
  ];

  configureFlags = [
    "--enable-xpdf-headers"
    "--disable-single-precision"
    "--disable-fixed-point"
    "--enable-cmyk"
    (enFlag "libopenjpeg" (openjpeg != null) null)
    (enFlag "libtiff" (libtiff != null) null)
    (enFlag "zlib" (zlib != null) null)
    (enFlag "libcurl" (curl != null) null)
    (enFlag "libjpeg" (libjpeg != null) null)
    (enFlag "libpng" (libpng != null) null)
    (wtFlag "font-configuration" (fontconfig != null) "fontconfig")
    #"--enable-splash"
    (enFlag "cairo-output" (cairo != null) null)
    (enFlag "poppler-glib" (
      cairo != null &&
      glib != null &&
      gobjectIntrospection != null) null)
    (enFlag "poppler-qt4" (qt4 != null) null)
    (enFlag "poppler-qt5" (qt5 != null) null)
    (enFlag "poppler-cpp" true null)
    #"gtk-test"
    (enFlag "utils" utils null)
    #"compile-warnings"
    #"cms"
    #"testdatadir"
  ];

  nativeBuildInputs = [
    pkgconfig
    libiconv
  ] ++ libintlOrEmpty;

  buildInputs = [
    cairo
    curl
    fontconfig
    freetype
    glib
    gobjectIntrospection
    lcms2
    libjpeg
    libpng
    libtiff
    openjpeg
    qt4
    zlib
  ] ++ optional (qt5 != null) qt5.base;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A PDF rendering library";
    homepage = http://poppler.freedesktop.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
