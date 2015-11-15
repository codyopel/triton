{ fetchurl, stdenv
, pkgconfig
, intltool
, perl
, perlXMLParser
, libxml2
, glib
, gtk3
, pango
, atk
, gdk_pixbuf
, shared_mime_info
, itstool
, gnome3
, ghostscriptX
, djvulibre
, libspectre
, libsecret
, makeWrapper
, librsvg
, recentListSize ? null # 5 is not enough, allow passing a different number
, gobjectIntrospection
, poppler
, xorg
}:

with {
  inherit (stdenv.lib)
    optionalString;
};

stdenv.mkDerivation rec {
  name = "evince-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${versionMajor}/${name}.tar.xz";
    sha256 = "05ybiqniqbn1nr4arksvc11bkb37z17shvhkmgnak0fqairnrba2";
  };

  configureFlags = [
    "--disable-nautilus" # Do not use nautilus
    "--enable-introspection"
  ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  preConfigure =
    optionalString doCheck ''
      for file in test/*.py; do
        echo "patching $file"
        sed '1s,/usr,${python},' -i "$file"
      done
    '' +
    optionalString (recentListSize != null) ''
      sed -i 's/\(gtk_recent_chooser_set_limit .*\)5)/\1${builtins.toString recentListSize})/' shell/ev-open-recent-action.c
      sed -i 's/\(if (++n_items == \)5\(.*\)/\1${builtins.toString recentListSize}\2/' shell/ev-window.c
    '';

  buildInputs = [
    pkgconfig
    intltool
    perl
    perlXMLParser
    libxml2
    glib
    gtk3
    pango
    atk
    gdk_pixbuf
    gobjectIntrospection
    itstool
    gnome3.adwaita-icon-theme
    gnome3.libgnome_keyring
    gnome3.gsettings_desktop_schemas
    poppler
    ghostscriptX
    djvulibre
    libspectre
    makeWrapper
    libsecret
    librsvg
    gnome3.adwaita-icon-theme
    xorg.libXi
    xorg.libXfixes
  ];

  preFixup = ''
    # Tell Glib/GIO about the MIME info directory, which is used
    # by `g_file_info_get_content_type ()'.
    wrapProgram "$out/bin/evince" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3}/share:${shared_mime_info}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"

  '';

  doCheck = false; # would need pythonPackages.dogTail, which is missing

  meta = with stdenv.lib; {
    description = "GNOME's document viewer";
    homepage = http://www.gnome.org/projects/evince/;
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
