{ stdenv, fetchurl
, pkgconfig
, intltool
, libtool
, glib
, dbus
, udev
, udisks2
, libgcrypt
, libgphoto2
, avahi
, libarchive
, fuse
, libcdio
, libxml2
, libxslt
, docbook_xsl
, samba
, libmtp
, gnome3
, gnomeSupport ? false
  , gnome
  , libgnome_keyring
  , gconf
  , gtk3
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "gvfs-${version}";
  versionMajor = "1.26";
  versionMinor = "1.1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${versionMajor}/${name}.tar.xz";
    sha256 = "0vf0dm4hsm2na5ws4cfby0zaj2xk69a8l5vv01zivnv4wj3gkb9d";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
  ];

  buildInputs = [
    makeWrapper
    glib
    dbus.libs
    udev udisks2
    libgcrypt
    libgphoto2
    avahi
    libarchive
    fuse
    libcdio
    libxml2
    libxslt
    docbook_xsl
    samba
    libmtp
    gnome3.gcr
  ] ++ stdenv.lib.optionals gnomeSupport [
    gtk3
    # ToDo: a ligther version of libsoup to have FTP/HTTP support?
    gnome.libsoup
    libgnome_keyring
    gconf
    # ToDo: not working and probably useless until gnome3 from x-updates
  ];

  # ToDo: one probably should specify schemas for samba and others here
  preFixup = ''
    wrapProgram $out/libexec/gvfsd --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}