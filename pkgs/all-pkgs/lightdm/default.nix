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
  versionMinor = "5";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "https://launchpad.net/lightdm/${versionMajor}/${version}/+download/${name}.tar.xz";
    sha256 = "1qb3gvwdm2rymwn8rb1qc4gyam226xmvy2fq5rvmrcmgxblmi34c";
  };

  patches = [
    ./fix-paths.patch
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (enFlag "introspection" (gobjectIntrospection != null) null)
    (enFlag "vala" (vala != null) null)
    "--disable-liblightdm-qt"
    (enFlag "liblightdm-qt5" (qt5 != null) null)
    (enFlag "libaudit" (libaudit != null) null)
    (enFlag "tests" doCheck null)
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-nls"
    #--with-user-session
    #--with-greeter-session
    #--with-greeter-user
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

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A lightweight display manager";
    homepage = https://launchpad.net/lightdm;
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}