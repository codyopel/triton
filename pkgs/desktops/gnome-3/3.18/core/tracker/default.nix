{ stdenv, fetchurl
, gettext
, gobjectIntrospection
, intltool
, itstool
, makeWrapper
, pkgconfig

, libxml2
, upower
, gtk3
, ffmpeg
, glib
, bash
, vala
, sqlite
, libxslt
, gnome3
, librsvg
, gdk_pixbuf
, file
, libnotify
, evolution
, evolution_data_server
, gst_all_1
, poppler
, icu
, taglib
, libjpeg
, libtiff
, giflib
, libcue
, libvorbis
, flac
, exempi
, networkmanager
, libpng
, libexif
, libgsf
, libuuid
, bzip2
, c-ares
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "tracker-${version}";
  versionMajor = "1.6";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker/${versionMajor}/${name}.tar.xz";
    sha256 = "12p2r5k7b19ikdd2cjljzr4y115rlckx064wv663zx14f9i2j9vy";
  };

  configureFlags = [
    "--enable-schemas-compile"
    "--disable-installed-tests"
    "--disable-always-build-tests"
    (enFlag "introspection" (gobjectIntrospection != null) null)
    "--enable-nls"
    "--disable-gcov"
    "--disable-minimal"
    "--disable-functional-tests"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-maemo"
    "--enable-journal"
    "--enable-libstreamer"
    "--enable-tracker-fts"
    "--disable-unit-tests"
    (enFlag "upower" (upower != null) null)
    "--disable-hal"
    (enFlag "network-manager" (networkmanager != null) null)
    # TODO: libmediaart support
    "--disable-libmediaart"
    (enFlag "libexif" (libexif != null) null)
    # TODO: libiptcdata support
    "--disable-libiptcdata"
    (enFlag "exempi" (exempi != null) null)
    "--enable-meegotouch"
    "--enable-miner-fs"
    "--enable-extract"
    "--enable-tracker-writeback"
    "--enable-miner-apps"
    "--enable-user-guides"
    # TODO: miner-rss support
    "--disable-miner-rss"
    # TODO: evolution plugin support
    "--disable-miner-evolution"
    # TODO: thunderbird support
    "--disable-miner-thunderbird"
    # TODO: firefox support
    "--disable-miner-firefox"
    # TODO: nautilus support
    "--disable-nautilus-extension"
    (enFlag "taglib" (taglib != null) null)
    "--enable-tracker-needle"
    "--enable-tracker-preferences"
    "--disable-enca"
    "--enable-icu-charset-detection"
    (enFlag "libxml2" (libxml2 != null) null)
    "--enable-cfg-man-pages"
    "--enable-unzip-ps-gz-files"
    (enFlag "poppler" (poppler != null) null)
    # TODO: libgxps support
    "--disable-libgxps"
    (enFlag "libgsf" (libgsf != null) null)
    # TODO: libosinfo support
    "--disable-libosinfo"
    (enFlag "libgif" (giflib != null) null)
    (enFlag "libjpeg" (libjpeg != null) null)
    (enFlag "libtiff" (libtiff != null) null)
    (enFlag "libpng" (libpng != null) null)
    (enFlag "libvorbis" (libvorbis != null) null)
    (enFlag "libflac" (flac != null) null)
    # TODO: libcue support
    "--disable-libcue"
    "--enable-abiword"
    "--enable-dvi"
    "--enable-mp3"
    "--enable-ps"
    "--enable-text"
    "--enable-icon"
    "--enable-playlist"
    "--enable-guarantee-metadata"
    "--enable-artwork"
    "--with-compile-warnings"
    #"--with-bash-completion-dir="
    #"--with-session-bus-services-dir"
    #"--with-unicode-support"
    #"--with-evolution-plugin-dir"
    #"--with-thunderbird-plugin-dir"
    #"--with-firefox-plugin-dir"
    #"--with-nautilus-extensions-dir"
    # TODO: gstreamer support
    "--with-gstreamer-backend=discoverer"
    #"--with-gstreamer-backend=gupnp-dlna"
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${gnome3.glib}/include/gio-unix-2.0"
    "-I${poppler}/include/poppler"
  ];

  preConfigure = ''
    substituteInPlace src/libtracker-sparql/Makefile.in \
      --replace \
        "--shared-library=libtracker-sparql" \
        "--shared-library=$out/lib/libtracker-sparql"
  '';

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  nativeBuildInputs = [
    gettext
    gobjectIntrospection
    intltool
    itstool
    libxslt
    makeWrapper
    pkgconfig
    vala
  ];

  propagatedBuildInputs = [
    glib # pkgconfig
  ];

  buildInputs = [
    bzip2
    c-ares
    #cairo
    #enca
    evolution
    evolution_data_server
    exempi
    file
    #firefox
    ffmpeg
    flac
    gdk_pixbuf
    giflib
    gnome3.defaultIconTheme
    gnome3.gsettings_desktop_schemas
    gnome3.libgee
    gnome3.totem-pl-parser
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    #gtk2
    gtk3
    #gupnp-dlna
    icu
    #libcue
    libexif
    #libgrss
    #libgxps
    libgsf
    #libiptcdata
    libjpeg
    #libmediaart
    libnotify
    #libosinfo
    libpng
    librsvg
    libtiff
    libuuid
    libvorbis
    libxml2
    networkmanager
    #pango
    poppler
    sqlite
    taglib
    #thunderbird
    upower
    #utillinux
  ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/* ; do
      wrapProgram $f \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "User information store, search tool and indexer";
    homepage = https://wiki.gnome.org/Projects/Tracker;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
