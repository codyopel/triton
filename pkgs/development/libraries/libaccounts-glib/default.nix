{ stdenv, fetchFromGitLab
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
  version = "1.19-pre";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "libaccounts-glib";
    rev = "61b5adaadc8efd1b8235580f0f8747fb62b40486";
    #url = "https://gitlab.com/accounts-sso/libaccounts-glib/repository/" +
    #      "archive.tar.gz?ref=${version}";
    sha256 = "1znsrnhm50sp09979v4y6q244ibzzg51b602pbxys2vxwvmzwhfh";
  };

  postPatch = ''
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

  makeFlags = [
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0/"
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

  enableParallelBuilding = true;
}
