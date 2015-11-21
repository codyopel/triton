{ stdenv, fetchurl
, intltool
, pkgconfig

, gtk3
, gnome3
, librsvg
, pango
, atk
, gtk2
, gdk_pixbuf
}:

stdenv.mkDerivation rec {
  name = "gnome-themes-standard-${version}";
  versionMajor = "3.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-standard/${versionMajor}/" +
          "${name}.tar.xz";
    sha256 = "1jxss8kxszhf66vic9n1sagczm5amm0mgxpzyxyjna15q82fnip6";
  };

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];
  
  buildInputs = [
    gtk3
    librsvg
    pango
    atk
    gtk2
    gdk_pixbuf
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
