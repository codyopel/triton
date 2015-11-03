{ stdenv, fetchurl
, gettext
, pkgconfig
, perl

, glib
, gobjectIntrospection
, libintlOrEmpty
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "atk-${version}";
  versionMajor = "2.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/${versionMajor}/${name}.tar.xz";
    sha256 = "0ay9s137x49f0akx658p7kznz0rdapfrd8ym54q0hlgrggblhv6f";
  };

  configureFlags = [
    "--enable-rebuilds"
    (enFlag "introspection" (gobjectIntrospection != null) null)
  ];

  nativeBuildInputs = [
    gettext
    perl
    pkgconfig
  ];

  propagatedBuildInputs = [
    gobjectIntrospection # pkgconfig
  ];

  buildInputs = [
    glib
    libintlOrEmpty
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Accessibility toolkit";
    homepage = http://library.gnome.org/devel/atk/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
