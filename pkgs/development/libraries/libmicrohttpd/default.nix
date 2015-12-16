{ stdenv, fetchurl
, pkgconfig

, curl
# Optional Dependencies
, openssl ? null
, zlib ? null
, libgcrypt ? null
, gnutls ? null
}:

with {
  inherit (stdenv)
    shouldUsePkg;
  inherit (stdenv.lib)
    mkEnable
    mkWith
    optional
    optionals;
};

let
  optOpenssl = shouldUsePkg openssl;
  optZlib = shouldUsePkg zlib;
  hasSpdy = optOpenssl != null && optZlib != null;

  optLibgcrypt = shouldUsePkg libgcrypt;
  optGnutls = shouldUsePkg gnutls;
  hasHttps = optLibgcrypt != null && optGnutls != null;
in

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.9.47";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "1335kznai5ih3kmavl1707sr4sakk0cc0srl5aax77x0a91spgcn";
  };

  configureFlags = [
    (mkWith true "threads" "posix")
    (mkEnable true "doc" null)
    (mkEnable false "examples" null)
    (mkEnable true "poll" "auto")
    (mkEnable true "epoll" "auto")
    (mkEnable true "socketpair" null)
    (mkEnable doCheck "curl" null)
    (mkEnable hasSpdy "spdy" null)
    (mkEnable true "messages" null)
    (mkEnable true "postprocessor" null)
    (mkWith hasHttps "gnutls" null)
    (mkEnable hasHttps "https" null)
    (mkEnable true "bauth" null)
    (mkEnable true "dauth" null)
    (mkEnable false "coverage" null)
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs =
    optional doCheck curl ++
    optionals hasSpdy [ optOpenssl optZlib ] ++
    optionals hasHttps [ optLibgcrypt optGnutls ];

  # Disabled because the tests can time-out.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Embeddable HTTP server library";
    homepage = http://www.gnu.org/software/libmicrohttpd/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
