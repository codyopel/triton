{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, itstool }:

stdenv.mkDerivation rec {
  name = "zenity-${version}";
  versionMajor = "3.18";
  versionMinor = "1.1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${versionMajor}/${name}.tar.xz";
    sha256 = "02m88dfm1rziqk2ywakwib06wl1rxangbzih6cp8wllbyl1plcg6";
  };

  preBuild = ''
    mkdir -p $out/include
  '';

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
