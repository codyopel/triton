{ stdenv, fetchurl, pkgconfig, gnome3, gtk3
, intltool, itstool, libxml2, systemd }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [ "--disable-tests" ];

  buildInputs = [
    pkgconfig gtk3 intltool itstool libxml2
    systemd gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Logs;
    description = "A log viewer for the systemd journal";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
