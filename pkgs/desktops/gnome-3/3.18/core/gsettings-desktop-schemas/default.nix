{ stdenv, fetchurl
, intltool
, pkgconfig

, glib
, gnome3
, gobjectIntrospection

# just for passthru
, gtk3
, gsettings_desktop_schemas
}:

stdenv.mkDerivation rec {
  name = "gsettings-desktop-schemas-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gsettings-desktop-schemas/${versionMajor}/${name}.tar.xz";
    sha256 = "06lsz789q3g4zdgzbqk0gn1ak3npk0gwikqvjy86asywlfr171r5";
  };

  postPatch = ''
    for file in "background" "screensaver" ; do
      substituteInPlace "schemas/org.gnome.desktop.$file.gschema.xml.in" \
        --replace "@datadir@" "${gnome3.gnome-backgrounds}/share/"
    done
  '';

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  buildInputs = [
    glib
    gobjectIntrospection
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
