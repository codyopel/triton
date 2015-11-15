{ stdenv, fetchFromGitHub
, perl
, yasm

, sizeLimitSupport ? true # limit max size to allow in the decoder
, realtimeOnlySupport ? false # build for real-time encoding
, ontheflyBitpackingSupport ? false # on-the-fly bitpacking in real-time encoding
, multiResEncodingSupport ? false # multiple-resolution encoding\
# Experimental features
, experimentalSpatialSvcSupport ? false # Spatial scalable video coding
, experimentalFpMbStatsSupport ? false
, experimentalEmulateHardwareSupport ? false
}:

with {
  inherit (stdenv)
    isi686
    isx86_64
    isArm
    is64bit;
  inherit (stdenv.lib)
    enFlag
    optional
    optionals;
};

stdenv.mkDerivation rec {
  name = "libvpx-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = "libvpx";
    rev = "v${version}";
    sha256 = "19ill4c7dak5f8m4pdbas87zknw3a34sca8a4i952q0l0jnif0np";
  };

  patchPhase = ''
    patchShebangs .
  '';

  configureFlags = [
    "--disable-extra-warnings"
    "--disable-werror"
    "--enable-optimizations"
    "--enable-pic"
    "--disable-ccache"
    "--disable-debug"
    "--disable-gprof"
    # TODO: Should ARM assembly be built in thumb mode?
    #(enFlag "thumb" isArm null)
    "--disable-thumb"
    "--disable-install-docs"
    "--enable-install-bins"
    "--enable-install-libs"
    "--disable-install-srcs"
    "--enable-libs"
    # The `vpxenc` executable is considered an example application
    "--enable-examples"
    "--disable-docs"
    "--disable-unit-tests"
    "--disable-decode-perf-tests"
    "--disable-encode-perf-tests"
    # Limit default decoder max to WHXGA
    (if sizeLimitSupport then "--size-limit=5120x3200" else null)
    "--as=yasm"
    "--disable-codec-srcs"
    "--disable-debug-libs"
    (enFlag "vp9-highbitdepth" is64bit null)
    "--enable-vp8"
    "--enable-vp8-decoder"
    "--enable-vp8-encoder"
    "--enable-vp9"
    "--enable-vp9-decoder"
    "--enable-vp9-encoder"
    "--disable-vp10"
    "--disable-vp10-decoder"
    "--disable-vp10-encoder"
    "--disable-internal-stats"
    "--enable-postproc"
    "--enable-vp9-postproc"
    "--enable-multithread"
    "--enable-spatial-resampling"
    (enFlag "realtime-only" realtimeOnlySupport null)
    (enFlag "onthefly-bitpacking" ontheflyBitpackingSupport null)
    "--disable-error-concealment"
    "--enable-coefficient-range-checking"
    "--enable-runtime-cpu-detect"
    "--disable-static"
    "--enable-shared"
    "--disable-small"
    "--disable-postproc-visualizer"
    "--enable-multi-res-encoding"
    "--enable-temporal-denoising"
    "--enable-vp9-temporal-denoising"
    "--enable-webm-io"
    "--enable-libyuv"
    (enFlag "experimental" (
      experimentalSpatialSvcSupport ||
      experimentalFpMbStatsSupport ||
      experimentalEmulateHardwareSupport) null)
    # Experimental features
  ] ++ optional experimentalSpatialSvcSupport "--enable-spatial-svc"
    ++ optional experimentalFpMbStatsSupport "--enable-fp-mb-stats"
    ++ optional experimentalEmulateHardwareSupport "--enable-emulate-hardware";

  nativeBuildInputs = [
    perl
    yasm
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "WebM VP8/VP9 codec SDK";
    homepage = http://www.webmproject.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
