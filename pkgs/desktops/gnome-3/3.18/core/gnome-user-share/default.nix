{ stdenv, intltool, fetchurl, apacheHttpd_2_2, nautilus
, pkgconfig, gtk3, glib, libxml2, gnused
, bash, itstool, libnotify, libtool, mod_dnssd
, gnome3, librsvg, gdk_pixbuf, file, libcanberra_gtk3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' -i data/dav_user_2.2.conf 
  '';

  configureFlags = [ "--with-httpd=${apacheHttpd_2_2}/bin/httpd"
                     "--with-modules-path=${apacheHttpd_2_2}/modules"
                     "--disable-bluetooth"
                     "--with-nautilusdir=$(out)/lib/nautilus/extensions-3.0" ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 libtool
                  file gdk_pixbuf gnome3.defaultIconTheme librsvg
                  nautilus libnotify libcanberra_gtk3 ];

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name
    ${glib}/bin/glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-user-share/3.8;
    description = "Service that exports the contents of the Public folder in your home directory on the local network";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
