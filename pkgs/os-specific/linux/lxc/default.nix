{ stdenv, fetchurl
, pkgconfig
, perl
, docbook2x
, docbook_xml_dtd_45
, python3Packages

# Optional Dependencies
, libapparmor ? null
, gnutls ? null
, libselinux ? null
, libseccomp ? null
, cgmanager ? null
, libnih ? null
, dbus ? null
, libcap ? null
, systemd ? null
}:

let
  enableCgmanager = cgmanager != null && libnih != null && dbus != null;
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxc-1.1.4";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxc/${name}.tar.gz";
    sha256 = "1p75ff4lnkm7hq26zq09nqbdypl508csk0ix024l7j8v02i2w1wg";
  };

  patches = [
    ./support-db2x.patch
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--enable-doc"
    "--disable-api-docs"
  ] ++ optional (libapparmor != null) "--enable-apparmor"
    ++ optional (libselinux != null) "--enable-selinux"
    ++ optional (libseccomp != null) "--enable-seccomp"
    ++ optional (libcap != null) "--enable-capabilities"
    ++ [
    "--disable-examples"
    "--enable-python"
    "--disable-lua"
    "--enable-bash"
    (if doCheck then "--enable-tests" else "--disable-tests")
    "--with-rootfs-path=/var/lib/lxc/rootfs"
  ];

  nativeBuildInputs = [
    pkgconfig
    perl
    docbook2x
    python3Packages.wrapPython
  ];

  buildInputs = [
    libapparmor
    gnutls
    libselinux
    libseccomp
    cgmanager
    libnih
    dbus
    libcap
    python3Packages.python
    systemd
  ];

  XML_CATALOG_FILES = "${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
    "sysconfigdir=\${out}/etc/default"
    "READMEdir=\${TMPDIR}/var/lib/lxc/rootfs"
    "LXCPATH=\${TMPDIR}/var/lib/lxc"
  ];

  postInstall = ''
    wrapPythonPrograms
  '';

  doCheck = false;

  meta = {
    description = "Userspace tools for Linux Containers";
    homepage = https://linuxcontainers.org/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
