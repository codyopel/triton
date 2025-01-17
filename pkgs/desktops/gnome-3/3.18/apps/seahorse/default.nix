{ stdenv, fetchurl
, intltool
, vala
, pkgconfig
, gtk3
, glib
, itstool
, gnupg
, libsoup
, gnome3
, librsvg
, gdk_pixbuf
, gpgme
, libsecret
, avahi
, p11_kit
, openssh
, libxml2
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [
    pkgconfig
    gtk3
    glib
    intltool
    itstool
    gnome3.gcr
    gnome3.gsettings_desktop_schemas
    gnupg
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    gpgme
    libsecret
    avahi
    libsoup
    p11_kit
    vala
    gnome3.gcr
    openssh
    libxml2
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Seahorse;
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
