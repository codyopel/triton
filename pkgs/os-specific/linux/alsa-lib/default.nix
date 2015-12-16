{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "alsa-lib-1.1.0";

  src = fetchurl {
    urls = [
     "ftp://ftp.alsa-project.org/pub/lib/${name}.tar.bz2"
     "http://alsa.cybermirror.org/lib/${name}.tar.bz2"
    ];
    sha256 = "058zmqyxvab85izcbls58f2phz7vq4l65av2wn18zdl23v8nbpnz";
  };

  patches = [
    ./alsa-plugin-conf-multilib.patch
  ];

  # Fix pcm.h file in order to prevent some compilation bugs
  # 2: see http://stackoverflow.com/questions/3103400/how-to-overcome-u-int8-t-vs-uint8-t-issue-efficiently
  postPatch = ''
    sed -i -e 's|//int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);|/\*int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);\*/|' include/pcm.h
    sed -i -e '1i#include <stdint.h>' include/pcm.h
    sed -i -e 's/u_int\([0-9]*\)_t/uint\1_t/g' include/pcm.h
  '';

  crossAttrs = {
    patchPhase = ''
      sed -i s/extern/static/g include/iatomic.h
    '';
  };

  meta = with stdenv.lib; {
    description = "ALSA, the Advanced Linux Sound Architecture libraries";
    homepage = http://www.alsa-project.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
