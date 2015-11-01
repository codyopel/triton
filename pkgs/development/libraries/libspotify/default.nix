{ stdenv, fetchurl
, libspotify
, alsaLib
, readline
, pkgconfig
, apiKey
, unzip
, gnused
}:

# https://developer.spotify.com/technologies/libspotify/

stdenv.mkDerivation rec {
  name = "libspotify-${version}";
  version = "12.1.51";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url    = "https://developer.spotify.com/download/libspotify/${name}-Linux-i686-release.tar.gz";
        sha256 = "1bjmn64gbr4p9irq426yap4ipq9rb84zsyhjjr7frmmw22xb86ll";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url    = "https://developer.spotify.com/download/libspotify/${name}-Linux-x86_64-release.tar.gz";
        sha256 = "0n0h94i4xg46hfba95n3ypah93crwb80bhgsg00f6sms683lx8a3";
      }
    else
      throw "libspotify does not support the `${stdenv.system}' platform";

  # no patch or build phase for darwin
  phases = [
    "unpackPhase"
    "patchPhase"
    "buildPhase"
    "installPhase"
  ];

  patchPhase = "${gnused}/bin/sed -i 's/ldconfig//' Makefile";

  # common
  buildPhase = "true";

  # linux-specific
  installFlags = "prefix=$(out)";

  postInstall = "mv -v share $out";

  passthru = {
    samples =
      if apiKey == null then
        throw ''
          Please visit ${libspotify.meta.homepage} to get an api key then set config.libspotify.apiKey accordingly
        ''
      else
        stdenv.mkDerivation {
          name = "libspotify-samples-${version}";
        
          src = libspotify.src;

          postUnpack = "sourceRoot=$sourceRoot/share/doc/libspotify/examples";

          patchPhase = "cp ${apiKey} appkey.c";
        
          buildInputs = [
            pkgconfig
            libspotify
            readline
            alsaLib
          ];

          installPhase = ''
            mkdir -p $out/bin
            install -m 755 jukebox/jukebox $out/bin
            install -m 755 spshell/spshell $out/bin
            install -m 755 localfiles/posix_stu $out/bin
          '';

          meta = libspotify.meta // {
            description = "Spotify API library samples";
          };
      };

    inherit apiKey;
  };

  meta = with stdenv.lib; {
    description = "Spotify API library";
    homepage = https://developer.spotify.com/technologies/libspotify;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
