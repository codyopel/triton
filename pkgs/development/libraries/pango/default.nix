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
, xorg
#, LibThai
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag;
};

stdenv.mkDerivation rec {
  name = "pango-${version}";
  versionMajor = "1.38";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${versionMajor}/${name}.tar.xz";
    sha256 = "1dsf45m51i4rcyvh5wlxxrjfhvn5b67d5ckjc6vdcxbddjgmc80k";
  };

  configureFlags = [
    "--enable-rebuilds"
    (enFlag "introspection" (gobjectIntrospection != null) "yes")
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-doc-cross-reference"
    "--enable-Bsymbolic"
    "--disable-installed-tests"
    (wtFlag "xft" (freetype != null) null)
    (wtFlag "cairo" (cairo != null) null)
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    cairo
    fontconfig
    freetype
    glib
    xorg.libXft
  ];

  buildInputs = [
    gobjectIntrospection
    harfbuzz
    libpng
    xorg.libXrender
  ] ++ libintlOrEmpty;

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
