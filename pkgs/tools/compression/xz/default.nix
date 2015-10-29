{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "xz-5.2.2";

  src = fetchurl {
    url = "http://tukaani.org/xz/${name}.tar.bz2";
    sha256 = "1da071wyx921pyx3zkxlnbpp14p6km98pnp66mg1arwi9dxgbxbg";
  };

  # In stdenv-linux, prevent a dependency on bootstrap-tools.
  preConfigure = "unset CONFIG_SHELL";

  postInstall = "rm -rf $out/share/doc";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "General-purpose data compression software";
    homepage = http://tukaani.org/xz/;
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
