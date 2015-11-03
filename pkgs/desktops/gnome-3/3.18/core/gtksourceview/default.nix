{ stdenv, fetchurl
, gettext
, intltool
, pkgconfig

, atk
, cairo
, glib
, gtk3
, pango
, libxml2Python
, perl
, gnome3
, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [
    "--enable-completion-providers"
    "--disable-glade-catalog"
    "--enable-nls"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-installed-tests"
    "--enable-introspection=yes"
    #"--enable-code-coverage"
    "--enable-vala=no"
  ];

  patches = [
    ./nix_share_path.patch
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    gtk3
  ];

  buildInputs = [
    atk
    cairo
    glib
    pango
    libxml2Python
    perl
    gobjectIntrospection
  ];

  preBuild = ''
    substituteInPlace gtksourceview/gtksourceview-utils.c \
      --replace "@NIX_SHARE_PATH@" "$out/share"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
