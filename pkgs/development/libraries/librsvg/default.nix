{ stdenv, fetchurl
, pkgconfig

, bzip2
, cairo
, gdk_pixbuf
, glib
, gobjectIntrospection
, libcroco
, libgsf
, libintlOrEmpty
, libxml2
, pango
}:

with {
  inherit (stdenv.lib)
    enFlag
    optional;
};

stdenv.mkDerivation rec {
  name = "librsvg-${version}";
  versionMajor = "2.40";
  versionMinor = "12";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url    = "mirror://gnome/sources/librsvg/${versionMajor}/${name}.tar.xz";
    sha256 = "0l5mzwlw6k20hvndvk5xllks20xbddr7b93rsvs9jf5zg11hrr7z";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-pixbuf-loader"
    "--enable-Bsymbolic"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-tools"
    (enFlag "introspection" (gobjectIntrospection != null) null)
    "--disable-vala"
  ];

  # It wants to add loaders and update the loaders.cache in gdk-pixbuf
  # Patching the Makefiles to it creates rsvg specific loaders and the
  # relevant loader.cache here.
  # The loaders.cache can be used by setting GDK_PIXBUF_MODULE_FILE to
  # point to this file in a wrapper.
  postConfigure = ''
    GDK_PIXBUF=$out/lib/gdk-pixbuf-2.0/2.10.0
    mkdir -p $GDK_PIXBUF/loaders
    sed -e "s#gdk_pixbuf_moduledir = .*#gdk_pixbuf_moduledir = $GDK_PIXBUF/loaders#" \
        -i gdk-pixbuf-loader/Makefile
    sed -e "s#gdk_pixbuf_cache_file = .*#gdk_pixbuf_cache_file = $GDK_PIXBUF/loaders.cache#" \
        -i gdk-pixbuf-loader/Makefile
    sed -e "s#\$(GDK_PIXBUF_QUERYLOADERS)#GDK_PIXBUF_MODULEDIR=$GDK_PIXBUF/loaders \$(GDK_PIXBUF_QUERYLOADERS)#" \
         -i gdk-pixbuf-loader/Makefile
  '';

  nativeBuildInputs = [
    gobjectIntrospection
    pkgconfig
  ];

  propagatedBuildInputs = [
    gdk_pixbuf
    glib
    cairo
  ];

  buildInputs = [
    bzip2
    libcroco
    libgsf
    libxml2
    pango
  ] ++ libintlOrEmpty;

  # Merge gdkpixbuf and librsvg loaders
  postInstall = ''
    mv $GDK_PIXBUF/loaders.cache $GDK_PIXBUF/loaders.cache.tmp
    cat ${gdk_pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache $GDK_PIXBUF/loaders.cache.tmp > $GDK_PIXBUF/loaders.cache
    rm $GDK_PIXBUF/loaders.cache.tmp
  '';

  enableParallelBuilding = true;
}
