{ stdenv, fetchurl
, intltool
, pkgconfig

, file
, glib
, gmime
, gobjectIntrospection
, libsoup
, libxml2

, gnome3
}:

stdenv.mkDerivation rec {
  name = "totem-pl-parser-${version}";
  versionMajor = "3.10";
  versionMinor = "5";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/totem-pl-parser/${versionMajor}/${name}.tar.xz";
    sha256 = "0dw1kiwmjwdjrighri0j9nagsnj44dllm0mamnfh4y5nc47mhim7";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-gmime-i-know-what-im-doing"
    # TODO: quvi support
    "--disable-quvi"
    # TODO: libarchive support
    "--disable-libarchive"
    # TODO: libgcrypt support
    "--disable-libgcrypt"
    "--disable-debug"
    "--enable-cxx-warnings"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-introspection"
    "--disable-code-coverage"
    #"--with-libgcrypt-prefix="
  ];

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    file
    gmime
    gobjectIntrospection
    libsoup
    libxml2
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
