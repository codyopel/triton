{ stdenv, fetchurl
, autoreconfHook
, makeWrapper
, perl

, coreutils
, gnused
, iproute
, iputils
, nettools
# Optional
, bind ? null
, openldap ? null
}:

with {
  inherit (stdenv)
    shouldUsePkg;
  inherit (stdenv.lib)
    mkEnable
    mkOther
    mkWith
    optionalString;
};

let
  optBind = shouldUsePkg bind;
  optOpenldap = shouldUsePkg openldap;
in

stdenv.mkDerivation rec {
  name = "dhcp-${version}";
  version = "4.3.3";
  
  src = fetchurl {
    url = "http://ftp.isc.org/isc/dhcp/${version}/${name}.tar.gz";
    sha256 = "1pjy4lylx7dww1fp2mk5ikya5vxaf97z70279j81n74vn12ljg2m";
  };

  postPatch = optionalString (optBind != null) ''
    # Don't use the built in bind
    rm -rf bind

    # Don't build an internal version of bind
    sed -i 's,^\(.*SUBDIRS.*\)bind\(.*\)$,\1\2,' Makefile.am

    # Use shared bind libraries instead of static
    grep -r 'bind/lib' . | awk -F: '{print $1}' | sort | uniq | xargs sed \
      -e "s,[^ ]*bind/lib/lib\([^.]*\)\.a,-l\1,g" \
      -i

    # Use our prebuilt version of bind
    ln -sv ${optBind} bind
  '';

  preConfigure = ''
    sed -i "includes/dhcpd.h" \
      -e "s|^ *#define \+_PATH_DHCLIENT_SCRIPT.*$|#define _PATH_DHCLIENT_SCRIPT \"$out/sbin/dhclient-script\"|g"
  '';

  configureFlags = [
    (mkOther                        "sysconfdir"     "/etc")
    (mkOther                        "localstatedir"  "/var")
    (mkEnable false                 "debug"          null)
    (mkEnable true                  "failover"       null)
    (mkEnable true                  "execute"        null)
    (mkEnable true                  "tracing"        null)
    (mkEnable true                  "delayed-ack"    null)  # Experimental in 4.3.2
    (mkEnable true                  "dhcpv6"         null)
    (mkEnable true                  "paranoia"       null)
    (mkEnable true                  "early-chroot"   null)
    (mkEnable true                  "ipv4-pktinfo"   null)
    (mkEnable false                 "use-sockets"    null)
    (mkEnable false                 "secs-byteorder" null)
    (mkEnable false                 "log-pid"        null)
    (mkWith   (optBind != null)     "libbind"        optBind)
    (mkWith   (optOpenldap != null) "ldap"           null)
    (mkWith   (optOpenldap != null) "ldapcrypto"     null)
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    perl
  ];

  buildInputs = [
    optBind
    optOpenldap
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  postInstall = ''
    cp client/scripts/linux $out/sbin/dhclient-script
    substituteInPlace $out/sbin/dhclient-script \
      --replace /sbin/ip ${iproute}/sbin/ip
    wrapProgram "$out/sbin/dhclient-script" --prefix PATH : \
      "${nettools}/bin:${nettools}/sbin:${iputils}/bin:${coreutils}/bin:${gnused}/bin"
  '';

  # all-recursive make failure
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Dynamic Host Configuration Protocol (DHCP) tools";
    homepage = http://www.isc.org/products/DHCP/;
    license = licenses.isc;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}
