{ stdenv, fetchurl
, perl
, cmake
, vala
, pkgconfig
, gobjectIntrospection
, glib
, gtk3
, gnome3
, gettext
}:

stdenv.mkDerivation rec {
  name = "granite-${version}";
  versionMajor = "0.3";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "https://code.launchpad.net/granite/${versionMajor}/${version}/" +
           "+download/${name}.tar.xz";
    sha256 = "1inyq9qhayzg1kl7nc6i275k9yqdicl23rs5lyrz2xdsk8gxdhcf";
  };

  cmakeFlags = [
    "-DINTROSPECTION_GIRDIR=share/gir-1.0/"
    "-DINTROSPECTION_TYPELIBDIR=lib/girepository-1.0"
  ];

  buildInputs = [
    perl
    cmake
    vala
    pkgconfig
    gobjectIntrospection
    glib
    gtk3
    gnome3.libgee
    gettext
  ];

  meta = with stdenv.lib; {
    description = "An extension to GTK+ used by elementary OS";
    homepage = https://launchpad.net/granite;
    license = licenses.lgpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
