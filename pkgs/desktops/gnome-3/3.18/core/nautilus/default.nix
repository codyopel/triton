{ stdenv, fetchurl
, gettext
, gobjectIntrospection
, intltool
, pkgconfig

, libxml2
, dbus_glib
, shared_mime_info
, libexif
, gtk3
, gvfs
, gnome3
, glib
, libunique
, libnotify
, exempi
, librsvg
, tracker
, pango
, xorg
}:

stdenv.mkDerivation rec {
  name = "nautilus-${version}";
  versionMajor = "3.18";
  versionMinor = "3";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${versionMajor}/${name}.tar.xz";
    sha256 = "17d96qxwzibclj2w7xfjh67d3bqp2h7h5jcah6gss8wifwi25024";
  };

  patches = [
    ./extension_dir.patch
  ];

  postPatch = ''
    sed -e 's/DISABLE_DEPRECATED_CFLAGS=.*/DISABLE_DEPRECATED_CFLAGS=/' \
        -i configure
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-schemas-compile"
    "--enable-nls"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-profiling"
    "--enable-nst-extension"
    "--enable-exif"
    "--enable-xmp"
    # Flag is not a proper boolean
    #"--disable-empty-view"
    "--enable-packagekit"
    "--enable-more-warnings"
    "--enable-tracker"
    "--enable-introspection"
    "--disable-update-mimedb"
  ];

  nativeBuildInputs = [
    gettext
    gobjectIntrospection
    intltool
    pkgconfig
  ];

  buildInputs = [
    dbus_glib
    exempi
    glib
    gnome3.adwaita-icon-theme
    gnome3.dconf
    gnome3.gnome_desktop
    gnome3.gsettings_desktop_schemas
    gtk3
    gvfs
    libexif
    libnotify
    librsvg
    libunique
    libxml2
    pango
    shared_mime_info
    tracker
  ];

  preFixup = ''
    gtk3AppsWrapperArgs+=("--prefix PATH ':' '$GSETTINGS_SCHEMAS_PATH:${gvfs}/bin'")
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
