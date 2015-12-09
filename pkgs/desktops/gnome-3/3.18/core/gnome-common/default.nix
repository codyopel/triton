{ stdenv, fetchurl
, which
, gnome3
, autoconf
, automake
}:

stdenv.mkDerivation rec {
  name = "gnome-common-3.18.0";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz;
    sha256 = "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf";
  };

  patches = [
    (fetchurl {
      name = "gnome-common-patch";
      url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
      sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
    })
  ];

  propagatedBuildInputs = [
    # autogen.sh which is using gnome_common tends to require which
    which
    autoconf
    automake
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
