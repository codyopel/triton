{ stdenv, fetchurl
, autoreconfHook
, bison
, flex
, gettext
, gobjectIntrospection
, libxslt
, pkgconfig

, glib
, libiconv

, dbus_daemon
}:

stdenv.mkDerivation rec {
  name = "vala-${version}";
  versionMajor = "0.30";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/vala/${versionMajor}/${name}.tar.xz";
    sha256 = "1pyyhfw3zzbhxfscbn8xz70dg6vx0kh8gshzikpxczhg01xk7w31";
  };

  postPatch = ''
    patchShebangs tests/testrunner.sh

    # Disable dbus tests, requires machine-id
    sed -e '/dbus\//d' -i tests/Makefile.am
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-unversioned"
    "--disable-coverage"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    gettext
    gobjectIntrospection
    libxslt
    pkgconfig
  ];

  buildInputs = [
    glib
    libiconv
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Compiler for GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
