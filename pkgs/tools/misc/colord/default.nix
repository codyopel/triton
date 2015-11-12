{ stdenv, fetchzip
, autoconf
, automake
, intltool
, pkgconfig

, argyllcms
, bashCompletion
, dbus
, glib
, gobjectIntrospection
, gusb
, lcms2
, libusb1
, polkit
, sqlite
, systemd
}:

stdenv.mkDerivation rec {
  name = "colord-1.2.12";

  src = fetchzip {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "0rvvbpxd5x479v4p6pck317mlf3j29s154i1n8hlx8n4znhwrb0k";
  };

  configureFlags = [
    "--enable-introspection"
    "--enable-schemas-compile"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-nls"
    "--disable-strict"
    "--enable-rpath"
    "--enable-gusb"
    "--enable-udev"
    "--disable-bash-completion"
    "--enable-polkit"
    "--enable-libcolordcompat"
    "--enable-systemd-login"
    "--disable-examples"
    "--enable-argyllcms-sensor"
    "--disable-reverse"
    "--disable-sane"
    "--disable-vala"
    "--disable-session-example"
    "--enable-print-profiles"
    "--disable-installed-tests"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevrulesdir=$out/lib/udev/rules.d"
    #"--with-daemon-user"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    pkgconfig
  ];

  buildInputs = [
    argyllcms
    bashCompletion
    dbus
    glib
    gobjectIntrospection
    gusb
    lcms2
    libusb1
    polkit
    sqlite
    systemd
  ];

  postInstall = ''
    rm -rvf $out/var/lib/colord
    mkdir -p $out/etc/bash_completion.d
    cp -v ./data/colormgr $out/etc/bash_completion.d
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Accurately color manage input and output devices";
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
