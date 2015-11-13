{ stdenv, fetchurl, pkgconfig, perl, texinfo, yasm
, ffmpeg
/*
 *  Licensing options (yes some are listed twice, filters and such are not listed)
 */
, gplLicensing ? true # GPL: fdkaac,openssl,frei0r,cdio,samba,utvideo,vidstab,x265,x265,xavs,avid,zvbi,x11grab
, version3Licensing ? true # (L)GPL3: opencore-amrnb,opencore-amrwb,samba,vo-aacenc,vo-amrwbenc
, nonfreeLicensing ? false # NONFREE: openssl,fdkaac,faac,aacplus,blackmagic-design-desktop-video
/*
 *  Build options
 */
, smallBuild ? false # Optimize for size instead of speed
, runtimeCpuDetectBuild ? true # Detect CPU capabilities at runtime (disable to compile natively)
, grayBuild ? true # Full grayscale support
, swscaleAlphaBuild ? true # Alpha channel support in swscale
, incompatibleLibavAbiBuild ? false # Incompatible Libav fork ABI
, hardcodedTablesBuild ? true # Hardcode decode tables instead of runtime generation
, safeBitstreamReaderBuild ? true # Buffer boundary checking in bitreaders
, memalignHackBuild ? false # Emulate memalign
, multithreadBuild ? true # Multithreading via pthreads/win32 threads
, networkBuild ? true # Network support
, pixelutilsBuild ? true # Pixel utils in libavutil
/*
 *  Program options
 */
, ffmpegProgram ? true # Build ffmpeg executable
, ffplayProgram ? true # Build ffplay executable
, ffprobeProgram ? true # Build ffprobe executable
, ffserverProgram ? true # Build ffserver executable
, qtFaststartProgram ? true # Build qt-faststart executable
/*
 *  Library options
 */
, avcodecLibrary ? true # Build avcodec library
, avdeviceLibrary ? true # Build avdevice library
, avfilterLibrary ? true # Build avfilter library
, avformatLibrary ? true # Build avformat library
, avresampleLibrary ? true # Build avresample library
, avutilLibrary ? true # Build avutil library
, postprocLibrary ? true # Build postproc library
, swresampleLibrary ? true # Build swresample library
, swscaleLibrary ? true # Build swscale library
/*
 *  Documentation options
 */
, htmlpagesDocumentation ? false # HTML documentation pages
, manpagesDocumentation ? true # Man documentation pages
, podpagesDocumentation ? false # POD documentation pages
, txtpagesDocumentation ? false # Text documentation pages
/*
 *  External libraries options
 */
#, aacplusExtlib ? false, aacplus ? null # AAC+ encoder
, alsaLib ? null # Alsa in/output support
#, avisynth ? null # Support for reading AviSynth scripts
, bzip2
, celt # CELT decoder
#, crystalhd ? null # Broadcom CrystalHD hardware acceleration
#, decklinkExtlib ? false, blackmagic-design-desktop-video ? null # Blackmagic Design DeckLink I/O support
, faacExtlib ? false, faac ? null # AAC encoder
, fdkaacExtlib ? false, fdk_aac ? null # Fraunhofer FDK AAC de/encoder
#, flite ? null # Flite (voice synthesis) support
, fontconfig # Needed for drawtext filter
, freetype # Needed for drawtext filter
, frei0r # frei0r video filtering
, fribidi # Needed for drawtext filter
, game-music-emu # Game Music Emulator
, gnutls
, gsm # GSM de/encoder
#, ilbc # iLBC de/encoder
, libjack2 # Jack audio (only version 2 is supported in this build)
, ladspaH # LADSPA audio filtering
, lame # LAME MP3 encoder
, libass # (Advanced) SubStation Alpha subtitle rendering
, libbluray # BluRay reading
, libbs2b # bs2b DSP library
, libcaca # Textual display (ASCII art)
#, libcdio-paranoia # Audio CD grabbing
, libdc1394, libraw1394 # IIDC-1394 grabbing (ieee 1394)
, libiconv
#, libiec61883 ? null, libavc1394 ? null # iec61883 (also uses libraw1394)
#, libmfx # Hardware acceleration vis libmfx
, libmodplug # ModPlug support
#, libnut # NUT (de)muxer, native (de)muser exists
, libogg # Ogg container used by vorbis & theora
, libopus # Opus de/encoder
, libsndio ? null # sndio playback/record support
, libssh # SFTP protocol
, libtheora # Theora encoder
, libv4l # Video 4 Linux support
, libva # Vaapi hardware acceleration
, libvdpau # Vdpau hardware acceleration
, libvorbis # Vorbis de/encoding, native encoder exists
, libvpx # VP8 & VP9 de/encoding
, libwebp # WebP encoder
, libX11 # Xlib support
, libxcb # X11 grabbing using XCB
, libxcbshmExtlib ? true # X11 grabbing shm communication
, libxcbxfixesExtlib ? true # X11 grabbing mouse rendering
, libxcbshapeExtlib ? true # X11 grabbing shape rendering
, libXv # Xlib support
, lzma # xz-utils
#, nvenc # NVIDIA NVENC support
, openal # OpenAL 1.1 capture support
#, opencl # OpenCL code
#, opencore-amr # AMR-NB de/encoder & AMR-WB decoder
#, opencv # Video filtering
, mesa_noglu # OpenGL rendering
#, openh264 # H.264/AVC encoder
, openjpeg_1 # JPEG 2000 de/encoder
, opensslExtlib ? false, openssl ? null
, libpulseaudio # Pulseaudio input support
, rtmpdump # RTMP[E] support
#, libquvi # Quvi input support
, samba # Samba protocol
#, schroedinger # Dirac de/encoder
, SDL
#, shine # Fixed-point MP3 encoder
, soxr # Resampling via soxr
, speex # Speex de/encoder
#, twolame # MP2 encoder
#, utvideo # Ut Video de/encoder
, vid-stab # Video stabilization
#, vo-aacenc ? null # AAC encoder
#, vo-amrwbenc ? null # AMR-WB encoder
, wavpack # Wavpack encoder
, x11grabExtlib ? false, libXext ? null, libXfixes ? null # X11 grabbing (legacy)
, x264 # H.264/AVC encoder
, x265 # H.265/HEVC encoder
, xavs # AVS encoder
, xvidcore # Xvid encoder, native encoder exists
, zeromq4 # Message passing
, zlib
#, zvbi ? null # Teletext support
/*
 *  Developer options
 */
, debugDeveloper ? false
, optimizationsDeveloper ? true
, extraWarningsDeveloper ? false
, strippingDeveloper ? false
}:

/* Maintainer notes:
 *
 * Version bumps:
 * It should always be safe to bump patch releases (e.g. 2.1.x, x being a patch release)
 * If adding a new branch, note any configure flags that were added, changed, or deprecated/removed
 *   and make the necessary changes.
 *
 * Packages with errors:
 *   flite ilbc schroedinger
 *   opencv - circular dependency issue
 *
 * Not packaged:
 *   aacplus avisynth cdio-paranoia crystalhd libavc1394 libiec61883
 *   libmxf libnut libquvi nvenc opencl opencore-amr openh264 oss shine twolame
 *   utvideo vo-aacenc vo-amrwbenc xvmc zvbi blackmagic-design-desktop-video
 *
 * Need fixes to support Darwin:
 *   frei0r, game-music-emu, gsm, libjack2, libssh, libvpx(stable 1.3.0), openal, openjpeg_1,
 *   pulseaudio, rtmpdump, samba, vid-stab, wavpack, x265. xavs
 *
 * Not supported:
 *   stagefright-h264(android only)
 *
 * Known issues:
 * flite: configure fails to find library
 *   Tried modifying ffmpeg's configure script and flite to use pkg-config
 * Cross-compiling will disable features not present on host OS
 *   (e.g. dxva2 support [DirectX] will not be enabled unless natively compiled on Cygwin)
 *
 */

with {
  inherit (stdenv)
    isFreeBSD
    isLinux;
  inherit (stdenv.lib)
    optional
    optionals
    enableFeature
    enFlag;
};

/*
 *  Licensing dependencies
 */
assert version3Licensing -> gplLicensing;
assert nonfreeLicensing -> gplLicensing && version3Licensing;
/*
 *  Build dependencies
 */
assert networkBuild -> gnutls != null || opensslExtlib;
assert pixelutilsBuild -> avutilLibrary;
/*
 *  Program dependencies
 */
assert ffmpegProgram -> avcodecLibrary
                     && avfilterLibrary
                     && avformatLibrary
                     && swresampleLibrary;
assert ffplayProgram -> avcodecLibrary
                     && avformatLibrary
                     && swscaleLibrary
                     && swresampleLibrary
                     && SDL != null;
assert ffprobeProgram -> avcodecLibrary && avformatLibrary;
assert ffserverProgram -> avformatLibrary;
/*
 *  Library dependencies
 */
assert avcodecLibrary -> avutilLibrary; # configure flag since 0.6
assert avdeviceLibrary -> avformatLibrary
                       && avcodecLibrary
                       && avutilLibrary; # configure flag since 0.6
assert avformatLibrary -> avcodecLibrary && avutilLibrary; # configure flag since 0.6
assert avresampleLibrary -> avutilLibrary;
assert postprocLibrary -> avutilLibrary;
assert swresampleLibrary -> soxr != null;
assert swscaleLibrary -> avutilLibrary;
/*
 *  External libraries
 */
#assert aacplusExtlib -> nonfreeLicensing;
#assert decklinkExtlib -> blackmagic-design-desktop-video != null
#                                       && !isCygwin && multithreadBuild # POSIX threads required
#                                       && nonfreeLicensing;
assert faacExtlib -> faac != null && nonfreeLicensing;
assert fdkaacExtlib -> fdk_aac != null && nonfreeLicensing;
assert gnutls != null -> !opensslExtlib;
assert libxcbshmExtlib -> libxcb != null;
assert libxcbxfixesExtlib -> libxcb != null;
assert libxcbshapeExtlib -> libxcb != null;
assert opensslExtlib -> gnutls == null && openssl != null && nonfreeLicensing;
assert x11grabExtlib -> libX11 != null && libXv != null;

stdenv.mkDerivation rec {
  name = "ffmpeg-full-${version}";
  version = ffmpeg.version;

  inherit (ffmpeg) src;

  patchPhase = ''patchShebangs .'';

  configureFlags = [
    /*
     *  Licensing flags
     */
    (enableFeature gplLicensing "gpl")
    (enableFeature version3Licensing "version3")
    (enableFeature nonfreeLicensing "nonfree")
    /*
     *  Build flags
     */
    # On some ARM platforms --enable-thumb
    "--enable-shared --disable-static"
    (enableFeature true "pic")
    (if stdenv.cc.isClang then "--cc=clang" else null)
    (enableFeature smallBuild "small")
    (enableFeature runtimeCpuDetectBuild "runtime-cpudetect")
    (enableFeature grayBuild "gray")
    (enableFeature swscaleAlphaBuild "swscale-alpha")
    (enableFeature incompatibleLibavAbiBuild "incompatible-libav-abi")
    (enableFeature hardcodedTablesBuild "hardcoded-tables")
    (enableFeature safeBitstreamReaderBuild "safe-bitstream-reader")
    (enableFeature memalignHackBuild "memalign-hack")
    (enFlag "pthreads" multithreadBuild null)
    "--disable-w32threads" # We don't support Windows
    "--disable-os2threads" # We don't support OS/2
    (enableFeature networkBuild "network")
    (enableFeature pixelutilsBuild "pixelutils")
    /*
     *  Program flags
     */
    (enableFeature ffmpegProgram "ffmpeg")
    (enableFeature ffplayProgram "ffplay")
    (enableFeature ffprobeProgram "ffprobe")
    (enableFeature ffserverProgram "ffserver")
    /*
     *  Library flags
     */
    (enableFeature avcodecLibrary "avcodec")
    (enableFeature avdeviceLibrary "avdevice")
    (enableFeature avfilterLibrary "avfilter")
    (enableFeature avformatLibrary "avformat")
    (enableFeature avresampleLibrary "avresample")
    (enableFeature avutilLibrary "avutil")
    (enableFeature (postprocLibrary && gplLicensing) "postproc")
    (enableFeature swresampleLibrary "swresample")
    (enableFeature swscaleLibrary "swscale")
    /*
     *  Documentation flags
     */
    (enableFeature (htmlpagesDocumentation
          || manpagesDocumentation
          || podpagesDocumentation
          || txtpagesDocumentation) "doc")
    (enableFeature htmlpagesDocumentation "htmlpages")
    (enableFeature manpagesDocumentation "manpages")
    (enableFeature podpagesDocumentation "podpages")
    (enableFeature txtpagesDocumentation "txtpages")
    /*
     *  External libraries
     */
    #(enableFeature aacplus "libaacplus")
    #(enableFeature avisynth "avisynth")
    (enFlag "bzlib" (bzip2 != null) null)
    (enFlag "libcelt" (celt != null) null)
    #(enableFeature crystalhd "crystalhd")
    #(enableFeature decklinkExtlib "decklink")
    (enableFeature faacExtlib "libfaac")
    (enableFeature (fdkaacExtlib && gplLicensing) "libfdk-aac")
    #(enableFeature (flite != null) "libflite")
    "--disable-libflite" # Force disable until a solution is found
    (enableFeature (fontconfig != null) "fontconfig")
    (enableFeature (freetype != null) "libfreetype")
    (enableFeature (frei0r != null && gplLicensing) "frei0r")
    (enableFeature (fribidi != null) "libfribidi")
    (enableFeature (game-music-emu != null) "libgme")
    (enableFeature (gnutls != null) "gnutls")
    (enableFeature (gsm != null) "libgsm")
    #(enableFeature (ilbc != null) "libilbc")
    (enableFeature (ladspaH !=null) "ladspa")
    (enableFeature (lame != null) "libmp3lame")
    (enableFeature (libass != null) "libass")
    #(enableFeature (libavc1394 != null) null null)
    (enableFeature (libbluray != null) "libbluray")
    (enableFeature (libbs2b != null) "libbs2b")
    #(enableFeature (libcaca != null) "libcaca")
    #(enableFeature (cdio-paranoia != null && gplLicensing) "libcdio")
    (enableFeature (if isLinux then libdc1394 != null && libraw1394 != null else false) "libdc1394")
    (enableFeature (libiconv != null) "iconv")
    #(enableFeature (if isLinux then libiec61883 != null && libavc1394 != null && libraw1394 != null else false) "libiec61883")
    #(enableFeature (libmfx != null) "libmfx")
    (enableFeature (libmodplug != null) "libmodplug")
    #(enableFeature (libnut != null) "libnut")
    (enableFeature (libopus != null) "libopus")
    (enableFeature (libssh != null) "libssh")
    (enableFeature (libtheora != null) "libtheora")
    (enableFeature (if isLinux then libv4l != null else false) "libv4l2")
    (enableFeature ((isLinux || isFreeBSD) && libva != null) "vaapi")
    (enableFeature (libvdpau != null) "vdpau")
    (enableFeature (libvorbis != null) "libvorbis")
    (enableFeature (libvpx != null) "libvpx")
    (enableFeature (libwebp != null) "libwebp")
    (enableFeature (libX11 != null && libXv != null) "xlib")
    (enableFeature (libxcb != null) "libxcb")
    (enableFeature libxcbshmExtlib "libxcb-shm")
    (enableFeature libxcbxfixesExtlib "libxcb-xfixes")
    (enableFeature libxcbshapeExtlib "libxcb-shape")
    (enableFeature (lzma != null) "lzma")
    #(enableFeature nvenc "nvenc")
    (enableFeature (openal != null) "openal")
    #(enableFeature opencl "opencl")
    #(enableFeature (opencore-amr != null && version3Licensing) "libopencore-amrnb")
    #(enableFeature (opencv != null) "libopencv")
    (enFlag "opengl" (mesa_noglu != null) null)
    #(enableFeature (openh264 != null) "openh264")
    (enableFeature (openjpeg_1 != null) "libopenjpeg")
    (enableFeature (opensslExtlib && gplLicensing) "openssl")
    (enableFeature (libpulseaudio != null) "libpulse")
    #(enableFeature quvi "libquvi")
    (enableFeature (rtmpdump != null) "librtmp")
    #(enableFeature (schroedinger != null) "libschroedinger")
    #(enableFeature (shine != null) "libshine")
    (enableFeature (samba != null && gplLicensing && version3Licensing) "libsmbclient")
    (enableFeature (SDL != null) "sdl") # Only configurable since 2.5, auto detected before then
    (enableFeature (soxr != null) "libsoxr")
    (enableFeature (speex != null) "libspeex")
    #(enableFeature (twolame != null) "libtwolame")
    #(enableFeature (utvideo != null && gplLicensing) "libutvideo")
    (enableFeature (vid-stab != null && gplLicensing) "libvidstab") # Actual min. version 2.0
    #(enableFeature (vo-aacenc != null && version3Licensing) "libvo-aacenc")
    #(enableFeature (vo-amrwbenc != null && version3Licensing) "libvo-amrwbenc")
    (enFlag "libwavpack" (wavpack != null) null)
    (enFlag "x11grab" (x11grabExtlib && gplLicensing) null)
    (enFlag "libx264" (x264 != null && gplLicensing) null)
    (enFlag "libx265" (x265 != null && gplLicensing) null)
    (enFlag "libxavs" (xavs != null && gplLicensing) null)
    (enFlag "libxvid" (xvidcore != null && gplLicensing) null)
    (enFlag "libzmq" (zeromq4 != null) null)
    (enFlag "zlib" (zlib != null) null)
    #(enableFeature (zvbi != null && gplLicensing) "libzvbi")
    /*
     * Developer flags
     */
    (enableFeature debugDeveloper "debug")
    (enableFeature optimizationsDeveloper "optimizations")
    (enableFeature extraWarningsDeveloper "extra-warnings")
    (enableFeature strippingDeveloper "stripping")
  ];

  nativeBuildInputs = [
    perl
    pkgconfig
    texinfo
    yasm
  ];

  buildInputs = [
    bzip2
    celt
    fontconfig
    freetype
    frei0r
    fribidi
    game-music-emu
    gnutls
    gsm
    libjack2
    ladspaH
    lame
    libass
    libbluray
    libbs2b
    libcaca
    libdc1394
    libmodplug
    libogg
    libopus
    libssh
    libtheora
    libvdpau
    libvorbis
    libvpx
    libwebp
    libX11
    libxcb
    libXext
    libXfixes
    libXv
    lzma
    mesa_noglu
    openal
    openjpeg_1
    libpulseaudio
    rtmpdump
    samba
    SDL
    soxr
    speex
    vid-stab
    wavpack
    x264
    x265
    xavs
    xvidcore
    zeromq4
    zlib
  ] ++ optionals x11grabExtlib [
    libXext
    libXfixes
  ] ++ optionals nonfreeLicensing [
    faac
    fdk_aac
    openssl
  ] ++ optionals isLinux [
    alsaLib
    libraw1394
    libv4l
  ] ++ optional ((isLinux || isFreeBSD) && libva != null) libva;

  # Build qt-faststart executable
  postBuild = optional qtFaststartProgram ''
    make tools/qt-faststart
  '';

  postInstall = optional qtFaststartProgram ''
    install -vD 'tools/qt-faststart' "$out/bin/qt-faststart"
  '';

  enableParallelBuilding = true;

  /* Cross-compilation is untested, consider this an outline, more work
     needs to be done to portions of the build to get it to work correctly */
  crossAttrs = let
    os = ''
      if [ "${stdenv.cross.config}" = "*cygwin*" ] ; then
        # Probably should look for mingw too
        echo "cygwin"
      elif [ "${stdenv.cross.config}" = "*darwin*" ] ; then
        echo "darwin"
      elif [ "${stdenv.cross.config}" = "*freebsd*" ] ; then
        echo "freebsd"
      elif [ "${stdenv.cross.config}" = "*linux*" ] ; then
        echo "linux"
      elif [ "${stdenv.cross.config}" = "*netbsd*" ] ; then
        echo "netbsd"
      elif [ "${stdenv.cross.config}" = "*openbsd*" ] ; then
        echo "openbsd"
      fi
    '';
  in {
    dontSetConfigureCross = true;
    configureFlags = configureFlags ++ [
      "--cross-prefix=${stdenv.cross.config}-"
      "--enable-cross-compile"
      "--target_os=${os}"
      "--arch=${stdenv.cross.arch}"
    ];
  };

  meta = with stdenv.lib; {
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
    homepage = http://www.ffmpeg.org/;
    license = (
      if nonfreeLicensing then
        licenses.unfreeRedistributable
      else if version3Licensing then
        licenses.gpl3
      else if gplLicensing then
        licenses.gpl2Plus
      else
        licenses.lgpl21Plus
    );
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
