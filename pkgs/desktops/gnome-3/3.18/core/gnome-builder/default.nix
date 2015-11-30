{ stdenv, fetchurl
, gettext
, gobjectIntrospection
, intltool
, pkgconfig

, llvmPackages
, gjs
, glib
, gtk3
, gtksourceview
, libgit2
, libgit2-glib
, libpeas
, librsvg
, libxml2
, pygobject
, python3
, uncrustify
, vala
, vte
, webkitgtk
}:

stdenv.mkDerivation rec {
  name = "gnome-builder-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-builder/${versionMajor}/" +
          "${name}.tar.xz";
    sha256 = "0z20wlv1i6w1srrmkabqxqx2rzkp4d4n7s28ax5a936g1li9a72h";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-introspection"
    "--enable-vala"
    "--enable-schemas-compile"
    "--enable-appstream-util"
    "--enable-rdtscp"
    "--disable-tracing"
    "--disable-debug"
    "--enable-autotools-plugin"
    "--enable-c-pack-plugin"
    "--enable-clang-plugin"
    "--enable-command-bar-plugin"
    "--enable-ctags-plugin"
    "--enable-device-manager-plugin"
    "--enable-file-search-plugin"
    "--disable-gnome-code-assistance-plugin"
    "--enable-html-completion-plugin"
    "--enable-html-preview-plugin"
    "--enable-jedi-plugin"
    "--enable-mingw-plugin"
    "--enable-python-gi-imports-completion-plugin"
    "--enable-python-pack-plugin"
    "--enable-symbol-tree-plugin"
    "--enable-sysmon-plugin"
    "--enable-terminal-plugin"
    "--enable-vala-pack-plugin"
    "--enable-xml-pack-plugin"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-optimizations"
    "--disable-profiling"
  ];

  nativeBuildInputs = [
    gettext
    gobjectIntrospection
    intltool
    pkgconfig
  ];

  buildInputs = [
    gjs
    glib
    gtk3
    gtksourceview
    libgit2
    libgit2-glib
    libpeas
    librsvg
    libxml2
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
    pygobject
    python3
    uncrustify
    vala
    vte
    webkitgtk
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Builder is a new IDE for GNOME";
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}