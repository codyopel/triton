{ stdenv, fetchurl
, autoreconfHook
, gtk_doc
, libtool
, libxslt
, pkgconfig

, glib
, gobjectIntrospection
, libxml2
, sqlite
}:

stdenv.mkDerivation rec {
  name = "libaccounts-glib-${version}";
  version = "1.18";

  src = fetchurl {
    url = "https://gitlab.com/accounts-sso/libaccounts-glib/repository/" +
          "archive.tar.gz?ref=${version}";
    sha256 = "1602cysf4l779ygscl9ylxkrjy3zlradnmji347bzz5xamawzksv";
  };

  postPatch = ''
    export HAVE_GCOV_FALSE='#'
    gtkdocize --copy --flavour no-tmpl
  '';

  configureFlags = [
    "--enable-introspection"
    "--disable-tests"
    "--disable-gcov"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-cast-checks"
    "--enable-asserts"
    "--enable-checks"
    "--disable-debug"
    "--enable-wal"
    "--enable-python"
    "--disable-man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    gtk_doc
    libtool
    libxslt
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    gobjectIntrospection
    libxml2
    sqlite
  ];
}
