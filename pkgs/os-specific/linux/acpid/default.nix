{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpid-2.0.25";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "0s2wg84x6pnrkf7i7lpzw2rilq4mj50vwb7p2b2n5hdyfa00lw0b";
  };

  makeFlags = [
    "BINDIR=$(out)/bin"
    "SBINDIR=$(out)/sbin"
    "MAN8DIR=$(out)/share/man/man8"
  ];

  meta = with stdenv.lib; {
    description = "A daemon for delivering ACPI events to userspace programs";
    homepage = http://tedfelix.com/linux/acpid-netlink.html;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
