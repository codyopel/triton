{ stdenv, fetchurl
, intltool
, itstool
, makeWrapper
, pkgconfig

, gobjectIntrospection
, gst_all_1
, clutter_gtk
, clutter-gst
, python
, pygobject3
, pylint
, shared_mime_info
, gtk3
, glib
, bash
, libxml2
, dbus_glib
, gnome3
, librsvg
, gdk_pixbuf
, file
# Plugins
, lirc
, vala
}:

stdenv.mkDerivation rec {
  name = "totem-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${versionMajor}/${name}.tar.xz";
    sha256 = "18h784c77m4h359j3xnlwqlfvnhbw7m052ahzm26r106jsp6x0fp";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-introspection"
    "--enable-glibtest"
    "--enable-easy-codec-installation"
    "--enable-python"
    "--enable-vala"
    "--enable-nautilus"
    "--enable-schemas-compile"
    "--disable-debug"
    "--enable-compile-warnings"
    "--enable-cxx-warnings"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-appstream-util"
    "--disable-run-in-source-tree"
    "--with-plugins=autodetect"
    #"--with-nautilusdir="
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${gnome3.glib}/include/gio-unix-2.0"
  ];

  nativeBuildInputs = [
    intltool
    itstool
    makeWrapper
    pkgconfig
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  buildInputs = [
    gobjectIntrospection
    gtk3
    glib
    libxml2
    gnome3.grilo
    clutter_gtk
    clutter-gst
    gnome3.totem-pl-parser
    gnome3.grilo-plugins
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gnome3.libpeas
    python
    pygobject3
    pylint
    shared_mime_info
    dbus_glib
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    gnome3.gnome_desktop
    gnome3.gsettings_desktop_schemas
    file
    # Plugins
    lirc
    vala
  ];

  preFixup = ''
    wrapProgram "$out/bin/totem" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix GRL_PLUGIN_PATH : "${gnome3.grilo-plugins}/lib/grilo-0.2" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"

  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
