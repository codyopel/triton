{ fetchurl, stdenv
, libuuid
, popt
, icu
, ncurses
}:

with {
  inherit (stdenv)
    isFreeBSD
    system;
  inherit (stdenv.lib)
    optionalString;
};

# TODO: add Cygwin support

stdenv.mkDerivation rec {
  name = "gptfdisk-1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/gptfdisk/${name}.tar.gz";
    sha256 = "1izazbyv5n2d81qdym77i8mg9m870hiydmq4d0s51npx5vp8lk46";
  };

  makefile =
    if isFreeBSD then
      "Makefile.freebsd"
    else
      "Makefile";

  buildInputs = [
    icu
    libuuid
    ncurses
    popt
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -v -m755 cgdisk $out/bin
    install -v -m755 fixparts $out/bin
    install -v -m755 gdisk $out/bin
    install -v -m755 sgdisk $out/bin

    mkdir -p $out/share/man/man8
    install -v -m644 cgdisk.8 $out/share/man/man8
    install -v -m644 fixparts.8 $out/share/man/man8
    install -v -m644 gdisk.8 $out/share/man/man8
    install -v -m644 sgdisk.8 $out/share/man/man8
  '';

  meta = with stdenv.lib; {
    description = "A set of text-mode partitioning tools for Globally Unique Identifier (GUID) Partition Table (GPT) disks";
    homepage = http://www.rodsbooks.com/gdisk/;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
