{ stdenv, fetchurl
, pkgconfig

, libevdev
, mtdev
, udev
, documentationSupport ? false
  , doxygen ? null
  , graphviz ? null
# GUI event viewer support
, eventGUISupport ? false
  , cairo ? null
  , glib ? null
  , gtk3 ? null
, testsSupport ? false
  , check ? null
  , valgrind ? null
}:

assert documentationSupport -> doxygen != null && graphviz != null;
assert eventGUISupport -> cairo != null && glib != null && gtk3 != null;
assert testsSupport -> check != null && valgrind != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libinput-1.1.3";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libinput/${name}.tar.xz";
    sha256 = "0plrd60wxxivh9427kb9zy5b4w2039lwxp8amxbikfg2j69z6nmr";
  };

  configureFlags = [
    (mkEnable documentationSupport "documentation" null)
    (mkEnable eventGUISupport      "event-gui"     null)
    (mkEnable testsSupport         "tests"         null)
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libevdev
    mtdev
    udev
  ] ++ optionals eventGUISupport [
    cairo
    glib
    gtk3
  ] ++ optionals documentationSupport [
    doxygen
    graphviz
  ] ++ optionals testsSupport [
    check
    valgrind
  ];

  meta = {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    homepage = http://www.freedesktop.org/wiki/Software/libinput;
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel wkennington ];
    platforms = platforms.unix;
  };
}
