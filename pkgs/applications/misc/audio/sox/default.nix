{ stdenv, fetchurl
  # Optional
, alsaLib
, amrnb
, amrwb
, flac
, lame
, libao
, libmad
, libogg
, libpng
, libsndfile
, libvorbis
}:

stdenv.mkDerivation rec {
  name = "sox-14.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/sox/${name}.tar.gz";
    sha256 = "0v2znlxkxxcd3f48hf3dx9pq7i6fdhb62kgj7wv8xggz8f35jpxl";
  };

  buildInputs = [
    alsaLib
    amrnb
    amrwb
    flac
    lame
    libao
    libmad
    libogg
    libpng
    libsndfile
    libvorbis
  ];

  meta = with stdenv.lib; {
    description = "Sample Rate Converter for audio";
    homepage = http://sox.sourceforge.net/;
    maintainers = [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}