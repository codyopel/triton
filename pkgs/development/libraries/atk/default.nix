{ stdenv, fetchurl
, gettext
, pkgconfig
, perl

, glib
, libintlOrEmpty
, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "atk-${version}";
  versionMajor = "2.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/${versionMajor}/${name}.tar.xz";
    sha256 = "0ay9s137x49f0akx658p7kznz0rdapfrd8ym54q0hlgrggblhv6f";
  };

  nativeBuildInputs = [
    gettext
    perl
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    gobjectIntrospection
    libintlOrEmpty
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    description = "Accessibility toolkit";
    homepage = http://library.gnome.org/devel/atk/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
