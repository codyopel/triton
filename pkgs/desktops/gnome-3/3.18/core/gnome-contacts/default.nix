{ stdenv, fetchurl
, autoconf
, automake
, intltool
, itstool
, pkgconfig

, evolution_data_server
, db
, gtk3
, glib
, libsecret
, libchamplain
, clutter_gtk
, geocode_glib
, bash
, folks
, libnotify
, libxml2
, gnome3
, librsvg
, gdk_pixbuf
, file
, telepathy_glib
, nspr
, nss
, libsoup
, vala
, dbus_glib
}:

stdenv.mkDerivation rec {
  name = "gnome-contacts-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${versionMajor}/${name}.tar.xz";
    sha256 = "09ng00kszzpa6al4j5ak4451i4gg34w89kjqvgs0ag77f1gd4604";
  };

  patches = [
    ./gio_unix.patch
  ];

  patchFlags = "-p0";

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    itstool
    pkgconfig
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
    evolution_data_server
  ];

  buildInputs = [
    gtk3
    glib
    evolution_data_server
    gnome3.gsettings_desktop_schemas
    file
    libnotify
    folks
    gnome3.gnome_desktop
    telepathy_glib
    libsecret
    dbus_glib
    libxml2
    libsoup
    gnome3.gnome_online_accounts
    nspr
    nss
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    libchamplain
    clutter_gtk
    geocode_glib
    vala
    db
  ];

  preBuild = ''
    # force build from vala
    touch src/*.vala
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Contacts is GNOME's integrated address book";
    homepage = https://wiki.gnome.org/Apps/Contacts;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
