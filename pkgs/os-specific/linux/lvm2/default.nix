{ stdenv, fetchurl, pkgconfig, udev, utillinux, coreutils, enable_dmeventd ? false }:

let
  version = "2.02.136";
in

stdenv.mkDerivation {
  name = "lvm2-${version}";

  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/releases/LVM2.${version}.tgz";
    sha256 = "135xk2i18y4mp9nk67iz2bx9q0yp7axmfkwcsd8xhz4ggl4r1by6";
  };

  configureFlags = [
    "--disable-readline"
    "--enable-udev_rules"
    "--enable-udev_sync"
    "--enable-pkgconfig"
    "--enable-applib"
    "--enable-cmdlib"
  ] ++ stdenv.lib.optional enable_dmeventd " --enable-dmeventd";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev ];

  preConfigure =
    ''
      substituteInPlace scripts/lvmdump.sh \
        --replace /usr/bin/tr ${coreutils}/bin/tr
      substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
        --replace /usr/sbin/lvm $out/sbin/lvm \
        --replace /usr/bin/udevadm ${udev}/bin/udevadm

      sed -i /DEFAULT_SYS_DIR/d Makefile.in
      sed -i /DEFAULT_PROFILE_DIR/d conf/Makefile.in
    '';

  enableParallelBuilding = true;

  #patches = [ ./purity.patch ];

  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";

  # Install systemd stuff.
  #installTargets = "install install_systemd_generators install_systemd_units install_tmpfiles_configuration";

  postInstall =
    ''
      substituteInPlace $out/lib/udev/rules.d/13-dm-disk.rules \
        --replace $out/sbin/blkid ${utillinux}/sbin/blkid

      # Systemd stuff
      mkdir -p $out/etc/systemd/system $out/lib/systemd/system-generators
      cp scripts/blk_availability_systemd_red_hat.service $out/etc/systemd/system
      cp scripts/lvm2_activation_generator_systemd_red_hat $out/lib/systemd/system-generators
    '';

  meta = {
    homepage = http://sourceware.org/lvm2/;
    descriptions = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    inherit version;
    downloadPage = "ftp://sources.redhat.com/pub/lvm2/";
  };
}
