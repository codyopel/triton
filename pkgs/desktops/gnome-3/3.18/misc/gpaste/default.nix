{ stdenv, fetchurl, intltool, autoreconfHook, pkgconfig, vala, glib
, pango, gtk3, gnome3, dbus, clutter, appstream-glib, makeWrapper }:

stdenv.mkDerivation rec {
  version = "${gnome3.version}.3";
  name = "gpaste-${version}";

  src = fetchurl {
    url = "https://github.com/Keruspe/GPaste/archive/v${version}.tar.gz";
    sha256 = "1czc707y2ksb8lgq1la0qkj3wpi202hjfiyshsndhw0pqn3qjj4a";
  };

  buildInputs = [ intltool autoreconfHook pkgconfig vala glib
                  gtk3 gnome3.gnome_control_center dbus.libs
                  clutter pango appstream-glib makeWrapper ];

  preConfigure = "intltoolize -f";

  configureFlags = [ "--with-controlcenterdir=$(out)/gnome-control-center/keybindings"
                     "--with-dbusservicesdir=$(out)/share/dbus-1/services" ];

  enableParallelBuilding = true;

  preFixup = 
    let
      libPath = stdenv.lib.makeLibraryPath
        [ glib gtk3 clutter pango ];
    in
    ''
      for i in $out/libexec/gpaste/*; do
        wrapProgram $i \
          --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
      done
    '';

    dontWrapGtk3Apps = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/Keruspe/GPaste;
    description = "Clipboard management system with GNOME3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
