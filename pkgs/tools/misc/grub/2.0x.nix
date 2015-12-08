{ stdenv, fetchurl, fetchFromSavannah
, autogen
, flex
, bison
, python
, autoconf
, automake

, gettext
, ncurses
, libusb
, freetype
, qemu
, devicemapper
, zfs ? null
, efiSupport ? false
, zfsSupport ? true
}:

with {
  inherit (stdenv.lib)
    any
    mapAttrsToList
    optional
    optionals;
};

let
  pcSystems = {
    "i686-linux".target = "i386";
    "x86_64-linux".target = "i386";
  };

  efiSystems = {
    "i686-linux".target = "i386";
    "x86_64-linux".target = "x86_64";
  };

  canEfi = any (system: stdenv.system == system) (mapAttrsToList (name: _: name) efiSystems);
  inPCSystems = any (system: stdenv.system == system) (mapAttrsToList (name: _: name) pcSystems);

  version = "2.x-2015-12-03";

  unifont_bdf = fetchurl {
    url = "http://unifoundry.com/unifont-5.1.20080820.bdf.gz";
    sha256 = "0s0qfff6n6282q28nwwblp5x295zd6n71kl43xj40vgvdqxv0fxx";
  };

  po_src = fetchurl {
    name = "grub-2.02-beta2.tar.gz";
    url = "http://alpha.gnu.org/gnu/grub/grub-2.02~beta2.tar.gz";
    sha256 = "1lr9h3xcx0wwrnkxdnkfjwy08j7g7mdlmmbdip2db4zfgi69h0rm";
  };
in

assert efiSupport -> canEfi;
assert zfsSupport -> zfs != null;

stdenv.mkDerivation rec {
  name = "grub-${version}";

  src = fetchFromSavannah {
    repo = "grub";
    rev = "a03c1034f6062e69075056c8f31b90e159ce5244";
    sha256 = "13spksy7aavf7gq6r4xc1mp3ahkidhxxgrwz6mz11hvwnyg3ysa6";
  };

  # save target that grub is compiled for
  grubTarget =
    if efiSupport then
      "${efiSystems.${stdenv.system}.target}-efi"
    else if inPCSystems then
      "${pcSystems.${stdenv.system}.target}-pc"
    else
      "";

  patches = [
    ./fix-bash-completion.patch
  ];

  prePatch = ''
    tar zxf ${po_src} grub-2.02~beta2/po
    rm -rf po
    mv grub-2.02~beta2/po po
    sh autogen.sh
    gunzip < "${unifont_bdf}" > "unifont.bdf"
    sed -e "s|/usr/src/unifont.bdf|$PWD/unifont.bdf|g" -i ./configure
  '';

  configureFlags = [ ]
    ++ optional zfsSupport "--enable-libzfs"
    ++ optionals efiSupport [
      "--with-platform=efi"
      "--target=${efiSystems.${stdenv.system}.target}"
      "--program-prefix="
    ];

  preConfigure = ''
    for i in "tests/util/"*.in ; do
      sed -i "$i" -e's|/bin/bash|/bin/sh|g'
    done

    # Apparently, the QEMU executable is no longer called
    # `qemu-system-i386', even on i386.
    #
    # In addition, use `-nodefaults' to avoid errors like:
    #
    #  chardev: opening backend "stdio" failed
    #  qemu: could not open serial device 'stdio': Invalid argument
    #
    # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
    sed -i "tests/util/grub-shell.in" \
        -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'
  '';

  nativeBuildInputs = [
    autoconf
    autogen
    automake
    bison
    flex
    python
  ];

  buildInputs = [
    devicemapper
    freetype
    gettext
    libusb
    ncurses
  ] ++ optional doCheck qemu
    ++ optional zfsSupport zfs;

  postInstall = ''
    paxmark pms $out/sbin/grub-{probe,bios-setup}
  '';

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GNU GRUB, the Grand Unified Boot Loader";
    homepage = http://www.gnu.org/software/grub/;
    license = licenses.gpl3Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
