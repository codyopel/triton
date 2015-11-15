{ stdenv, intltool, fetchurl, evolution_data_server, db
, pkgconfig, gtk3, glib, libsecret
, libchamplain, clutter_gtk, geocode_glib
, bash, makeWrapper, itstool, folks, libnotify, libxml2
, gnome3, librsvg, gdk_pixbuf, file, telepathy_glib, nspr, nss
, libsoup, vala, dbus_glib, automake115x, autoconf }:

stdenv.mkDerivation rec {
  name = "gnome-contacts-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${versionMajor}/${name}.tar.xz";
    sha256 = "09ng00kszzpa6al4j5ak4451i4gg34w89kjqvgs0ag77f1gd4604";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard evolution_data_server ];

  # force build from vala
  preBuild = ''
   touch src/*.vala
  '';

  buildInputs = [ pkgconfig gtk3 glib intltool itstool evolution_data_server
                  gnome3.gsettings_desktop_schemas makeWrapper file libnotify
                  folks gnome3.gnome_desktop telepathy_glib libsecret dbus_glib
                  libxml2 libsoup gnome3.gnome_online_accounts nspr nss
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  libchamplain clutter_gtk geocode_glib
                  vala automake115x autoconf db ];

  preFixup = ''
    for f in "$out/bin/gnome-contacts" "$out/libexec/gnome-contacts-search-provider"; do
      wrapProgram $f \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  patches = [ ./gio_unix.patch ];

  patchFlags = "-p0";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Contacts;
    description = "Contacts is GNOME's integrated address book";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
