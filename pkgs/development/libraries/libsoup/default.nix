{ stdenv, fetchurl
, gettext
, intltool
, pkgconfig
, python

, glib
, glib_networking
, gobjectIntrospection
, libintlOrEmpty
, libxml2
, sqlite
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "libsoup-${version}";
  versionMajor = "2.53";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${versionMajor}/${name}.tar.xz";
    sha256 = "0ydvlv4v49kp7rxmvpirqqv4558sgagr9i12zz376ydf0zpaq1cb";
  };

  postPatch = ''
    patchShebangs ./libsoup/
  '';

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = [
    "--enable-nls"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    (enFlag "introspection" (gobjectIntrospection != null) "yes")
    "--disable-vala"
    "--disable-tls-check"
    "--with-gnome"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
    python
  ];

  buildInputs = [
    glib_networking
    libxml2
    sqlite
  ] ++ libintlOrEmpty;

  propagatedBuildInputs = [
    glib # pkgconfig
    gobjectIntrospection # pkgconfig
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  passthru = {
    propagatedUserEnvPackages = [
      glib_networking
    ];
  };

  meta = {
    inherit (glib.meta)
      maintainers
      platforms;
  };
}
