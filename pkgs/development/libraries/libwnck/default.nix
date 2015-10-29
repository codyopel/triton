{ stdenv, fetchurl
, pkgconfig
, gtk2
, intltool
, xorg
}:

stdenv.mkDerivation rec {
  name = "libwnck-${version}";
  versionMajor = "2.31";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libwnck/${versionMajor}/${name}.tar.xz";
    sha256 = "17isfjvrzgj5znld2a7zsk9vd39q9wnsysnw5jr8iz410z935xw3";
  };

  configureFlags = [
    "--disable-introspection"
  ];

  # ?another optional: startup-notification
  buildInputs = [
    pkgconfig
    gtk2
    intltool
    xorg.libX11
    xorg.libXres
  ];

  meta = {
    description = "A library for creating task lists and pagers";
    license = stdenv.lib.licenses.lgpl21;
  };
}
