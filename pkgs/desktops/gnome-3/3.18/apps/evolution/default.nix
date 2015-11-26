{ stdenv, fetchurl
, intltool

, libxml2
, webkitgtk
, highlight
, pkgconfig
, gtk3
, glib
, libnotify
, gtkspell3
, itstool
, shared_mime_info
, libical
, db
, gcr
, sqlite
, gnome3
, librsvg
, gdk_pixbuf
, libsecret
, nss
, nspr
, icu
, libtool
, libcanberra_gtk3
, bogofilter
, gst_all_1
, procps
, p11_kit
}:

let
  majVer = gnome3.version;
in stdenv.mkDerivation rec {
  name = "evolution-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution/${versionMajor}/${name}.tar.xz";
    sha256 = "132as4z30dykl3a8avlcwy7nhd83haxd85xagrjn8sbypbx3xf4i";
  };

  configureFlags = [
    "--disable-spamassassin"
    "--disable-pst-import"
    "--disable-autoar"
    "--disable-libcryptui"
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${nspr}/include/nspr"
    "-I${nss}/include/nss"
    "-I${glib}/include/gio-unix-2.0"
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  nativeBuildInputs = [
    intltool
    itstool
    libtool
    pkgconfig
  ];

  propagatedBuildInputs = [
    gnome3.gtkhtml
  ];

  buildInputs = [
    gtk3
    glib
    libxml2
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    db
    icu
    gnome3.evolution_data_server
    libsecret
    libical
    gcr
    webkitgtk
    shared_mime_info
    gnome3.gnome_desktop
    gtkspell3
    libcanberra_gtk3
    bogofilter
    gnome3.libgdata
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    p11_kit
    nss
    nspr
    libnotify
    procps
    highlight
    gnome3.libgweather
    gnome3.gsettings_desktop_schemas
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Integrated mail, calendaring and address book";
    homepage = https://wiki.gnome.org/Apps/Evolution;
    license = licenses.lgpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
