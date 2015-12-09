{ stdenv, fetchurl
, pkgconfig

, glib
, gobjectIntrospection
, libsoup
, libxml2
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "rest-${version}";
  versionMajor = "0.7";
  versionMinor = "93";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/rest/${versionMajor}/${name}.tar.xz";
    sha256 = "05mj10hhiik23ai8w4wkk5vhsp7hcv24bih5q3fl82ilam268467";
  };

  configureFlags = [
    (enFlag "introspection" (gobjectIntrospection != null) "yes")
    "--with-gnome"
    "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib # pkgconfig
    libsoup # pkgconfig
    libxml2 # pkgconfig
  ];

  buildInputs = [
    gobjectIntrospection
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
