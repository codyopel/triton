{ stdenv, fetchurl
, pkgconfig

, etcDir ? null
, libedit
, openssl
, pam
, perl
, zlib
, hpnSupport ? false
, withKerberos ? false
  , kerberos
}:

with {
  inherit (stdenv.lib)
    optional
    optionalString
    wtFlag;
};

assert withKerberos -> kerberos != null;

let
  hpnSrc = fetchurl {
    url = mirror://sourceforge/hpnssh/openssh-7_1_P1-hpn-14.9.diff;
    sha256 = "682b4a6880d224ee0b7447241b6843304731018585f1ba519f46660c10d63950";
  };
in

stdenv.mkDerivation rec {
  name = "openssh-7.1p1";

  src = fetchurl {
    url = "mirror://openbsd/OpenSSH/portable/${name}.tar.gz";
    sha256 = "0a44mnr8bvw41zg83xh4sb55d8nds29j95gxvxk5qg863lnns2pw";
  };

  patches = [
    ./locale_archive.patch
  ];

  prePatch = optionalString hpnSupport ''
    gunzip -c ${hpnSrc} | patch -p1
    export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
  '';

  # Set --disable-strip because later we strip anyway. And it fails to strip
  # properly when cross building.
  configureFlags = [
    "--localstatedir=/var"
    "--with-mantype=man"
    "--with-libedit=yes"
    "--disable-strip"
    (wtFlag "pam" (pam != null) null)
  ] ++ optional (etcDir != null) "--sysconfdir=${etcDir}"
    ++ optional withKerberos "--with-kerberos5=${kerberos}";

  preConfigure = ''
    configureFlagsArray+=("--with-privsep-path=$out/empty")
    mkdir -p $out/empty
  '';

  buildInputs = [
    zlib
    openssl
    libedit
    pkgconfig
    pam
  ] ++ optional withKerberos kerberos;

  installFlags = [
    "sysconfdir=\${out}/etc/ssh"
  ];

  postInstall = ''
    # Install ssh-copy-id, it's very useful.
    cp contrib/ssh-copy-id $out/bin/
    chmod +x $out/bin/ssh-copy-id
    cp contrib/ssh-copy-id.1 $out/share/man/man1/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An implementation of the SSH protocol";
    homepage = "http://www.openssh.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
