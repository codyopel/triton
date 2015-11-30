{ stdenv, fetchurl
, gobjectIntrospection
, libtool
, pkgconfig

, glib
, gnome3
, libgit2
, libssh2
, pygobject
, python3
, vala
}:

stdenv.mkDerivation rec {
  name = "libgit2-glib-${version}";
  versionMajor = "0.23";
  versionMinor = "6";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgit2-glib/${versionMajor}/${name}.tar.xz";
    sha256 = "0i0ig3xndnx9xl47mrqcljc8jv9v8qvyylhcrfb4pdhsp1f6p3aw";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-debug"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-ssh"
    "--enable-python"
    "--enable-vala"
    "--enable-compile-warnings"
  ];

  nativeBuildInputs = [
    gobjectIntrospection
    libtool
    pkgconfig
  ];

  buildInputs = [
    glib
    gnome3.gnome_common
    libgit2
    libssh2
    pygobject
    python3
    vala
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
