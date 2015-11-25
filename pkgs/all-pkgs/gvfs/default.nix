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
, libgudev
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
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${versionMajor}/${name}.tar.xz";
    sha256 = "064dsjrdjcbi38zl38jhh4r9jcpiygg7x4c8s6s2rb757l7nwnv9";
  };

  nativeBuildInputs = [
    docbook_xsl
    intltool
    libtool
    libxslt
    makeWrapper
    pkgconfig
  ];

  buildInputs = [
    avahi
    dbus.libs
    fuse
    glib
    gnome3.gcr
    libarchive
    libcdio
    libgudev
    libgcrypt
    libgphoto2
    libmtp
    libxml2
    samba
    udev
    udisks2
  ] ++ stdenv.lib.optionals gnomeSupport [
    gconf
    gnome.libsoup
    gtk3
    libgnome_keyring
  ];

  # ToDo: one probably should specify schemas for samba and others here
  preFixup = ''
    wrapProgram $out/libexec/gvfsd \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}