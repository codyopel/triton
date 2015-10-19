{ stdenv, fetchurl
, perl
}:

stdenv.mkDerivation rec {
  name = "mbedtls-1.3.14";

  src = fetchurl {
    url = "https://polarssl.org/download/${name}-gpl.tgz";
    sha256 = "1y3gr3kfai3d13j08r4pv42sh47nbfm4nqi9jq8c9d06qidr2xmy";
  };

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "SHARED=1"
  ];

  nativeBuildInputs = [
    perl
  ];

  installFlags = [
    "DESTDIR=\${out}"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Portable cryptographic and SSL/TLS library, aka polarssl";
    homepage = https://polarssl.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
