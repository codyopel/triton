{ stdenv, fetchurl
, gobjectIntrospection
, intltool
, itstool
, libtool
, pkgconfig

, glib
, libxml2
, xorg
, dbus
, accountsservice
, libX11
, gnome3
, systemd
, gnome_session
, gtk3
, libcanberra_gtk3
, pam
}:

stdenv.mkDerivation rec {
  name = "gdm-${version}";
  versionMajor = "3.14";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${versionMajor}/${name}.tar.xz";
    sha256 = "e20eb61496161ad95b1058dbf8aea9b7b004df4d0ea6b0fab4401397d9db5930";
  };

  # Disable Access Control because our X does not support
  # FamilyServerInterpreted yet
  patches = [
    ./xserver_path.patch
    ./sessions_dir.patch
    ./disable_x_access_control.patch
    ./no-dbus-launch.patch
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemd=yes"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure \
      --replace "/usr/bin/X" "${xorg.xorgserver}/bin/X"
  '';

  nativeBuildInputs = [
    gobjectIntrospection
    intltool
    itstool
    libtool
    pkgconfig
  ];

  buildInputs = [
    accountsservice
    glib
    gnome3.dconf
    gtk3
    libcanberra_gtk3
    libxml2
    pam
    systemd
    xorg.libX11
    xorg.libXi
    xorg.libXrandr
  ];

  preBuild = ''
    substituteInPlace daemon/gdm-simple-slave.c \
      --replace 'BINDIR "/gnome-session' '"${gnome_session}/bin/gnome-session'
  '';

  installFlags = [
    "sysconfdir=$(out)/etc"
    "dbusconfdir=$(out)/etc/dbus-1/system.d"
  ];

  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    description = "Manages display servers and graphical user logins";
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
