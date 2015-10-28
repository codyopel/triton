{ stdenv, fetchurl
, gettext
, intltool
, itstool
, pkgconfig

, accountsservice
, glib
, gobjectIntrospection
, libaudit
, libgcrypt
, libxklavier
, libxml2
, pam
, qt5 ? null
, vala
, xorg
}:

with {
  inherit (stdenv.lib)
    enFlag
    optionals;
};

stdenv.mkDerivation rec {
  name = "lightdm-${version}";
  versionMajor = "1.16";
  versionMinor = "3";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "https://launchpad.net/lightdm/${versionMajor}/${version}/+download/${name}.tar.xz";
    sha256 = "0jsvpg86nzwzacnr1bfzw81432j6m6lg2daqgy04ywj976k0x2y8";
  };

  patches = [
    ./fix-paths.patch
  ];

  configureFlags = [
    (enFlag "liblightdm-qt" false null)
    (enFlag "liblightdm-qt5" (qt5 != null) null)
    (enFlag "libaudit" true null)
    (enFlag "tests" true null)
    #--with-user-session
    #--with-greeter-session
    #--with-greeter-user
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    itstool
    pkgconfig
  ];

  buildInputs = [
    accountsservice
    glib
    gobjectIntrospection
    libaudit
    libgcrypt
    libxklavier
    libxml2
    pam
    vala
    xorg.libX11
    xorg.libxcb
    xorg.libXdmcp
  ] ++ optionals (qt5 != null) [
    qt5.base
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A lightweight display manager";
    homepage = https://launchpad.net/lightdm;
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}