{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpi-${version}";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/acpiclient/${version}/${name}.tar.gz";
    sha256 = "01ahldvf0gc29dmbd5zi4rrnrw2i1ajnf30sx2vyaski3jv099fp";
  };

  meta = with stdenv.lib; {
    description = "Show battery status and other ACPI information";
    homepage = http://sourceforge.net/projects/acpiclient/;
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
