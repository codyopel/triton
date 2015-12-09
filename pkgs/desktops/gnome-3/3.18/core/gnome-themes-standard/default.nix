{ stdenv, fetchurl
, gettext
, intltool
, pkgconfig

, cairo
, gnome3
, gtk2
, gtk3
, librsvg
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

  configureFlags = [
    "--enable-glibtest"
    "--enable-nls"
    "--enable-gtk3-engine"
    "--enable-gtk2-engine"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];
  
  buildInputs = [
    cairo
    gtk2
    gtk3
    gnome3.defaultIconTheme
    librsvg
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
