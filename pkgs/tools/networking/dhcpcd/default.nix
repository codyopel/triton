{ stdenv, fetchurl
, pkgconfig

, udev
}:

with {
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "dhcpcd-6.9.4";

  src = fetchurl {
    url = "mirror://roy/dhcpcd/${name}.tar.xz";
    sha256 = "184vpid8m5175xa2nkh6mmvk8b6z4isfm6nvf4g8l5ggfdsgzwy3";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  makeFlags = [
    "PREFIX=\${out}"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    udev
  ];

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = "DBDIR=\${TMPDIR}/db SYSCONFDIR=$(out)/etc";

  # Check that the udev plugin was built.
  postInstall = optional (udev != null) "[ -e $out/lib/dhcpcd/dev/udev.so ]";

  meta = with stdenv.lib; {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = http://roy.marples.name/projects/dhcpcd;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
