{ stdenv, fetchurl
, docbook_xsl
, intltool
, libtool
, libxslt
, pkgconfig

, avahi
, dbus
, fuse
, gconf
, glib
, gnome3
, gtk3
, libarchive
, libbluray
, libcdio
, libgcrypt
, libgnome_keyring
, libgphoto2
, libgudev
, libmtp
, libsecret
, libsoup
, libxml2
, openssh
, samba
, systemd
, udev
, udisks2
}:

stdenv.mkDerivation rec {
  name = "gvfs-${version}";
  versionMajor = "1.26";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${versionMajor}/${name}.tar.xz";
    sha256 = "064dsjrdjcbi38zl38jhh4r9jcpiygg7x4c8s6s2rb757l7nwnv9";
  };

  configureFlags = [
    "--disable-documentation"
    "--enable-schemas-compile"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-gcr"
    "--enable-nls"
    "--enable-http"
    "--enable-avahi"
    "--enable-udev"
    "--enable-fuse"
    "--enable-gdu"
    "--enable-udisks2"
    "--enable-libsystemd-login"
    "--enable-hal"
    "--enable-gudev"
    "--enable-cdda"
    "--enable-afc"
    "--enable-goa"
    "--enable-google"
    "--enable-gphoto2"
    "--enable-keyring"
    "--enable-bluray"
    "--enable-libmtp"
    "--enable-samba"
    "--enable-gtk"
    "--enable-archive"
    "--enable-afp"
    "--disable-nfs"
    "--enable-bash-completion"
    "--enable-more-warnings"
    "--enable-installed-tests"
    "--enable-always-build-tests"
    #"--with-bash-completion-dir="
  ];

  nativeBuildInputs = [
    docbook_xsl
    intltool
    libtool
    libxslt
    pkgconfig
  ];

  buildInputs = [
    avahi
    dbus
    fuse
    glib
    gnome3.gcr
    gnome3.gnome_online_accounts
    gnome3.libgdata
    libarchive
    libbluray
    libcdio
    libgudev
    libgcrypt
    libgphoto2
    libmtp
    libsecret
    libsoup
    libxml2
    openssh
    samba
    systemd
    udev
    udisks2
    #gconf
    gtk3
    libgnome_keyring
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}