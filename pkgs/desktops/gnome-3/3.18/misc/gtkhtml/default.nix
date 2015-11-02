{ stdenv, fetchurl
, pkgconfig
, gtk3
, intltool
, gnome3
, enchant
, isocodes
, xorg
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedBuildInputs = [
    enchant
    isocodes
  ];

  buildInputs = [
    pkgconfig
    gtk3
    intltool
    gnome3.adwaita-icon-theme
    gnome3.gsettings_desktop_schemas
    xorg.libSM
    xorg.libICE
  ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
