{ fetchurl, stdenv
, gettext
, pkgconfig

, cairo
, glib
, gnome3
, gobjectIntrospection
, gtk3
, libffi
, libxml2
, pango
, readline
, spidermonkey_24
, xorg
}:

stdenv.mkDerivation rec {
  name = "gjs-${version}";
  versionMajor = "1.44";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${versionMajor}/${name}.tar.xz";
    sha256 = "106fgpr4y99sj68l72pnfa2za11ps4bn6p9z28fr79j7mpv61jc8";
  };

  configureFlags = [
    "--enable-cxx-warnings"
    "--disable-coverage"
    "--disable-systemtap"
    "--disable-dtrace"
    "--enable-Bsymbolic"
    "--with-cairo"
    "--with-gtk"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
  ];

  buildInputs = [
    cairo
    glib
    gnome3.gnome_common
    gtk3
    libffi
    libxml2
    pango
    readline
    xorg.libICE
    xorg.libSM
  ];

  propagatedBuildInputs = [
    gobjectIntrospection
    spidermonkey_24
  ];

  postInstall = ''
    sed 's|-lreadline|-L${readline}/lib -lreadline|g' -i $out/lib/libgjs.la
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
