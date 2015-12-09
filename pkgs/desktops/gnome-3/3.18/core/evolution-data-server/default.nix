{ fetchurl, stdenv
, gettext
, intltool
, pkgconfig

, db
, gcr
, glib
, gnome3
, gnome_online_accounts
, gperf
, gsettings_desktop_schemas
, gtk3
, icu
, kerberos
, libaccounts-glib
, libgdata
, libgweather
, libical
, libsecret
, libsoup
, libxml2
, openldap
, nspr
, nss
, p11_kit
, python
, sqlite
# Optional
, vala
, gobjectIntrospection
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "evolution-data-server-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${versionMajor}/" +
          "${name}.tar.xz";
    sha256 = "16yfd2a00xqxikyf6pi2awfd0qfq4hwdhfar88axrb4mycfgqhjr";
  };

  # uoa irrelevant for now
  configureFlags = [
    "--enable-schemas-compile"
    "--disable-maintainer-mode"
    "--enable-nls"
    "--disable-code-coverage"
    "--disable-installed-tests"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-gtk"
    "--disable-examples"
    "--enable-goa"
    # TODO: requires libsignon-glib
    "--disable-uoa"
    "--enable-backend-per-process"
    "--disable-backtraces"
    "--enable-smime"
    "--enable-ipv6"
    "--enable-weather"
    "--enable-dot-locking"
    "--enable-file-locking"
    "--disable-purify"
    "--enable-google"
    "--enable-largefile"
    "--enable-glibtest"
    "--enable-introspection"
    (enFlag "vala-bindings" (vala != null) null)
    # TODO: libphonenumber support
    "--without-phonenumber"
    "--without-private-docs"
    "--with-libdb=${db}"
    "--with-krb5=${kerberos}"
    "--with-openldap"
    "--without-static-ldap"
    "--without-sunldap"
    "--without-static-sunldap"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    libical
    libsecret
    libxml2
    nspr
    nss
    sqlite
  ];

  buildInputs = [
    db
    gcr
    gnome_online_accounts
    gobjectIntrospection
    gperf
    gsettings_desktop_schemas
    icu
    kerberos
    libaccounts-glib
    libgdata
    libgweather
    libsoup
    openldap
    p11_kit
    python
    vala
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
