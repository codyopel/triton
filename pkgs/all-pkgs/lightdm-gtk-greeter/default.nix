{ stdenv, fetchurl
, gettext
, intltool
, makeWrapper
, pkgconfig

, at_spi2_core
, gobjectIntrospection
, hicolor_icon_theme
, gtk3
, libxklavier
, lightdm
, xorg
}:

stdenv.mkDerivation rec {
  name = "lightdm-gtk-greeter-${version}";
  versionMajor = "2.0";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "http://launchpad.net/lightdm-gtk-greeter/${versionMajor}/${version}/"
        + "+download/${name}.tar.gz";
    sha256 = "031iv7zrpv27zsvahvfyrm75zdrh7591db56q89k8cjiiy600r1j";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-introspection"
    "--enable-compile-warnings"
    #"--enable-libindicator"
    #"--enable-libido"
    #"--enable-at-spi-command=command"
    #"--enable-indicator-services-command=command"
    "--disable-kill-on-sigterm"
    "--enable-nls"
    "--with-libxklavier"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    makeWrapper
    pkgconfig
  ];

  buildInputs = [
    at_spi2_core
    gobjectIntrospection
    gtk3
    libxklavier
    lightdm
    xorg.libX11
  ];

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
      --replace "Exec=lightdm-gtk-greeter" "Exec=$out/sbin/lightdm-gtk-greeter"

    wrapProgram "$out/sbin/lightdm-gtk-greeter" \
      --prefix XDG_DATA_DIRS ":" "${hicolor_icon_theme}/share"
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "LightDM GTK+ Greeter";
    homepage = http://launchpad.net/lightdm-gtk-greeter;
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}