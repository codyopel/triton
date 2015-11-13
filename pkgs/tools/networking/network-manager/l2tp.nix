{ stdenv, fetchFromGitHub
, substituteAll
, automake
, autoconf
, libtool
, intltool
, pkgconfig
, networkmanager
, ppp
, xl2tpd
, strongswan
, withGnome ? true
  , gnome3
, xorg
}:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-l2tp";
  version = "0.9.8.7";

  src = fetchFromGitHub {
    owner = "seriyps";
    repo = "NetworkManager-l2tp";
    rev = version;
    sha256 = "07gl562p3f6l2wn64f3vvz1ygp3hsfhiwh4sn04c3fahfdys69zx";
  };

  patches = [
    (substituteAll {
      src = ./l2tp-purity.patch;
      inherit
        xl2tpd
        strongswan;
    })
  ];

  configureFlags =
    if withGnome then "--with-gnome" else "--without-gnome";

  configureScript = "./autogen.sh";

  postConfigure = "sed 's/-Werror//g' -i Makefile */Makefile";

  buildInputs = [
    networkmanager
    ppp
    xorg.libICE
    xorg.libSM
  ] ++ stdenv.lib.optionals withGnome [
    gnome3.gtk3
    gnome3.libgnome_keyring
  ];

  nativeBuildInputs = [
    automake
    autoconf
    libtool
    intltool
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "L2TP plugin for NetworkManager";
    inherit (networkmanager.meta) platforms;
    homepage = https://github.com/seriyps/NetworkManager-l2tp;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
