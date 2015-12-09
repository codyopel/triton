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
, xorg
}:

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${versionMajor}/${name}.tar.xz";
    sha256 = "1rpdg8rcjlqv8yk13vsh5148mads0zbfih8cak3hm7wb0spmzsbv";
  };

  patches = [
    ./nix_share_path.patch
  ];

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-compile-warnings"
    "--enable-Werror"
    "--enable-deprecations"
    "--enable-completion-providers"
    "--disable-glade-catalog"
    "--enable-nls"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-installed-tests"
    "--enable-introspection"
    "--disable-code-coverage"
    "--disable-vala"
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
    xorg.libICE
    xorg.libSM
  ];

  preBuild = ''
    substituteInPlace gtksourceview/gtksourceview-utils.c \
      --replace "@NIX_SHARE_PATH@" "$out/share"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
