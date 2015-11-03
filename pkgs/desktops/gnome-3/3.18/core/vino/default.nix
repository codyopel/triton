{ stdenv, fetchurl
, intltool
, gtk3
, glib
, libsoup
, pkgconfig
, makeWrapper
, gnome3
, libnotify
, file
, telepathy_glib
, dbus_glib
, xorg
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  buildInputs = [
    gtk3
    intltool
    glib
    libsoup
    pkgconfig
    libnotify
    gnome3.defaultIconTheme
    dbus_glib
    telepathy_glib
    file
    makeWrapper
    xorg.libSM
];

  preFixup = ''
    wrapProgram "$out/libexec/vino-server" \
      --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Vino;
    description = "GNOME desktop sharing server";
    maintainers = with maintainers; [ lethalman iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
