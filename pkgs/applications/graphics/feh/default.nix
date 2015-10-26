{ stdenv, fetchurl
, makeWrapper

, xlibsWrapper
, imlib2
, libjpeg
, libpng
, libXinerama
, curl
, libexif
}:

stdenv.mkDerivation rec {
  name = "feh-2.14";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "0j5wxpqccnd0hl74z2vwv25n7qnik1n2mcm2jn0c0z7cjn4wsa9q";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "exif=1"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    xlibsWrapper
    imlib2 libjpeg
    libpng
    libXinerama
    curl
    libexif
  ];

  postInstall = ''
    wrapProgram "$out/bin/feh" \
      --prefix PATH : "${libjpeg}/bin" \
      --add-flags '--theme=feh'
  '';

  meta = with stdenv.lib; {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
