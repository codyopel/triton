{ stdenv, fetchurl
, gettext
, pkgconfig

, dbus
, expat
, glib
}:

stdenv.mkDerivation rec {
  name = "dbus-glib-0.104";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus-glib/${name}.tar.gz";
    sha256 = "1xi1v1msz75qs0s4lkyf1psrksdppa3hwkg0mznc6gpw5flg3hdz";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-tests"
    "--disable-gcov"
    "--disable-bash-completion"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
  ];

  nativeBuildInputs = [
    pkgconfig
    gettext
  ];

  propagatedBuildInputs = [
    dbus.libs
    glib
  ];

  buildInputs = [
    expat
  ];

  outputs = [ "out" "doc" ];

  doCheck = true;

  passthru = {
    inherit
      dbus
      glib;
  };

  meta = with stdenv.lib; {
    description = "Obsolete glib bindings for D-Bus lightweight IPC mechanism";
    homepage = http://dbus.freedesktop.org;
    license = with licenses; [ afl21 gpl2 ];
    maintainers = [ ];
  };
}
