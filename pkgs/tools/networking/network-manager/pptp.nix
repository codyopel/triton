{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig, substituteAll
, libsecret, withGnome ? true, gnome3 }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-pptp";
  version = networkmanager.version;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/1.0/${pname}-${version}.tar.xz";
    sha256 = "05r06f7f990z908jjnmmryrlshy28wcx7fbvnslmx9nicih7rjrp";
  };

  buildInputs = [ networkmanager pptp ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk3 gnome3.libgnome_keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome";

  postConfigure = "sed 's/-Werror//g' -i Makefile */Makefile";

  patches =
    [ ( substituteAll {
        src = ./pptp-purity.patch;
        inherit ppp pptp;
      })
    ];

  meta = {
    description = "PPtP plugin for NetworkManager";
    inherit (networkmanager.meta) maintainers platforms;
  };
}
