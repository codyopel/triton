{ stdenv, fetchurl
, makeWrapper
, pkgconfig

, dbus
, glib
, libusb
, alsaLib
, python
, pythonDBus
, pygobject
, readline
, libsndfile
}:

assert stdenv.isLinux;

let
  pythonpath = "${pythonDBus}/lib/${python.libPrefix}/site-packages:"
    + "${pygobject}/lib/${python.libPrefix}/site-packages";
in
   
stdenv.mkDerivation rec {
  name = "bluez-4.101";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "11vldy255zkmmpj0g0a1m6dy9bzsmyd7vxy02cdfdw79ml888wsr";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-cups"
    "--with-systemdunitdir=$(out)/etc/systemd/system"
  ];

  buildInputs = [
    pkgconfig
    dbus.libs
    glib
    libusb
    alsaLib
    python
    makeWrapper
    readline
    libsndfile
      # Disables GStreamer; not clear what it gains us other than a
      # zillion extra dependencies.
      # gstreamer gst_plugins_base 
  ];

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  makeFlags = "rulesdir=$(out)/lib/udev/rules.d";

  /* !!! Move these into a separate package to prevent Bluez from
    depending on Python etc. */
  postInstall = ''
    pushd test
    for a in simple-agent test-adapter test-device test-input; do
      cp $a $out/bin/bluez-$a
      wrapProgram $out/bin/bluez-$a --prefix PYTHONPATH : ${pythonpath}
    done
    popd
  '';

  meta = {
    description = "Bluetooth support for Linux";
    homepage = http://www.bluez.org/;
  };
}
