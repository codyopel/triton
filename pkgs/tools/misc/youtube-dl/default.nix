{ stdenv, fetchurl
, buildPythonPackage
, makeWrapper
#, pandoc ? null

, ffmpeg
, zip
}:

# Pandoc is required to build the package's man page. Release tarballs
# contain a formatted man page already, though, so it's fine to pass
# "pandoc = null" to this derivation; the man page will still be
# installed. We keep the pandoc argument and build input in place in
# case someone wants to use this derivation to build a Git version of
# the tool that doesn't have the formatted man page included.

buildPythonPackage rec {
  name = "youtube-dl-${version}";
  version = "2015.10.24";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "1q9srq08vb2yzl81hmjrgqwajckq52fhh9ag2ppbbxjibf91w5gs";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc"
  ];

  nativeBuildInputs = [
    makeWrapper
    #pandoc
  ];

  buildInputs = [
    zip
  ];


  # Include FFmpeg for post-processing & transcoding support
  # Ensure ffmpeg is available in $PATH for youtube-dl
  postInstall = stdenv.lib.optionalString (ffmpeg != null) ''
    wrapProgram $out/bin/youtube-dl \
      --prefix PATH : "${ffmpeg}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Command-line tool to download videos from YouTube.com and other sites";
    homepage = http://rg3.github.com/youtube-dl/;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
