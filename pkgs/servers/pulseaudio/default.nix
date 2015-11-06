{ stdenv, fetchurl
, pkgconfig
, intltool
, automake
, autoconf
, libtool
, json_c
, libsndfile
, gettext
, check

# Optional Dependencies
, alsaLib ? null
, avahi ? null
, bluez ? null
, coreaudio ? null
, dbus ? null
, esound ? null
, fftw ? null
, gconf ? null
, glib ? null
, gtk3 ? null
, libasyncns ? null
, libcap ? null
, libjack2 ? null
, lirc ? null
, openssl ? null
, oss ? null
, sbc ? null
, soxr ? null
, speexdsp ? null
, systemd ? null
, udev ? null
, valgrind ? null
, webrtc-audio-processing ? null
, xorg ? null

# Database selection
, tdb ? null
, gdbm ? null

# Extra options
, prefix ? ""
}:

with {
  inherit (stdenv)
    shouldUsePkg;
  inherit (stdenv.lib)
    enFlag
    otFlag
    wtFlag
    optionals
    optionalString;
};

let
  libOnly = prefix == "lib";
  ifFull =
    a:
    if libOnly then
      null
    else
      a;

  hasXlibs = xorg != null;

  optLibcap = shouldUsePkg libcap;
  hasCaps = optLibcap != null || stdenv.isFreeBSD; # Built-in on FreeBSD

  optOss = ifFull (shouldUsePkg oss);
  hasOss = optOss != null || stdenv.isFreeBSD; # Built-in on FreeBSD

  optCoreaudio = ifFull (shouldUsePkg coreaudio);
  optAlsaLib = ifFull (shouldUsePkg alsaLib);
  optEsound = ifFull (shouldUsePkg esound);
  optGlib = shouldUsePkg glib;
  optGtk3 = ifFull (shouldUsePkg gtk3);
  optGconf = ifFull (shouldUsePkg gconf);
  optAvahi = ifFull (shouldUsePkg avahi);
  optLibjack2 = ifFull (shouldUsePkg libjack2);
  optLibasyncns = shouldUsePkg libasyncns;
  optLirc = ifFull (shouldUsePkg lirc);
  optDbus = shouldUsePkg dbus;
  optSbc = ifFull (shouldUsePkg sbc);
  optBluez =
    if optDbus == null || optSbc == null then
      null
    else
      shouldUsePkg bluez;
  optUdev = ifFull (shouldUsePkg udev);
  optOpenssl = ifFull (shouldUsePkg openssl);
  optFftw = shouldUsePkg fftw;
  optSpeexdsp = shouldUsePkg speexdsp;
  optSoxr = ifFull (shouldUsePkg soxr);
  optSystemd = shouldUsePkg systemd;
  optWebrtc-audio-processing = ifFull (shouldUsePkg webrtc-audio-processing);
  hasWebrtc = ifFull (optWebrtc-audio-processing != null);

  # Pick a database to use
  databaseName = if tdb != null then "tdb" else
    if gdbm != null then "gdbm" else "simple";
  database = {
    tdb = tdb;
    gdbm = gdbm;
    simple = null;
  }.${databaseName};
in

stdenv.mkDerivation rec {
  name = "${prefix}pulseaudio-${version}";
  version = "7.1";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/"
        + "pulseaudio-${version}.tar.xz";
    sha256 = "1ndrac0j528lsg3b8wcsgvzds38ml0ja4m57xsn953rj51552rz6";
  };

  patches = [
    ./caps-fix.patch
  ];

  configureFlags = [
    (otFlag "localstatedir" true "/var")
    (otFlag "sysconfdir" true "/etc")
    (enFlag "atomic-arm-memory-barrier" false null) # TODO: Enable on armv8
    (enFlag "neon-opt" false null) # TODO: Enable on armv8
    (enFlag "x11" hasXlibs null)
    (wtFlag "caps" hasCaps optLibcap)
    (enFlag "tests" true null)
    (enFlag "samplerate" false null) # Deprecated
    (wtFlag "database" true databaseName)
    (enFlag "oss-output" hasOss null)
    (enFlag "oss-wrapper" true null) # Does not use OSS
    (enFlag "coreaudio-output" (optCoreaudio != null) null)
    (enFlag "alsa" (optAlsaLib != null) null)
    (enFlag "esound" (optEsound != null) null)
    (enFlag "solaris" false null)
    (enFlag "waveout" false null) # Windows Only
    (enFlag "glib2" (optGlib != null) null)
    (enFlag "gtk3" (optGtk3 != null) null)
    (enFlag "gconf" (optGconf != null) null)
    (enFlag "avahi" (optAvahi != null) null)
    (enFlag "jack" (optLibjack2 != null) null)
    (enFlag "asyncns" (optLibasyncns != null) null)
    (enFlag "tcpwrap" false null)
    (enFlag "lirc" (optLirc != null) null)
    (enFlag "dbus" (optDbus != null) null)
    (enFlag "bluez4" false null)
    (enFlag "bluez5" (optBluez != null) null)
    (enFlag "bluez5-ofono-headset" (optBluez != null) null)
    (enFlag "bluez5-native-headset" (optBluez != null) null)
    (enFlag "udev" (optUdev != null) null)
    (enFlag "hal-compat" false null)
    (enFlag "ipv6" true null)
    (enFlag "openssl" (optOpenssl != null) null)
    (wtFlag "fftw" (optFftw != null) null)
    (wtFlag "speex" (optSpeexdsp != null) null)
    (wtFlag "soxr" (optSoxr != null) null)
    (enFlag "xen" false null)
    (enFlag "gcov" false null)
    (enFlag "systemd-daemon" (optSystemd != null) null)
    (enFlag "systemd-login" (optSystemd != null) null)
    (enFlag "systemd-journal" (optSystemd != null) null)
    (enFlag "manpages" true null)
    (enFlag "webrtc-aec" hasWebrtc null)
    (enFlag "adrian-aec" true null)
    (wtFlag "system-user" true "pulse")
    (wtFlag "system-group" true "pulse")
    (wtFlag "access-group" true "audio")
    (wtFlag "systemduserunitdir" true "\${out}/lib/systemd/user")
    (wtFlag "bash-completion-dir" true
      "\${out}/share/bash-completions/completions")
  ];

  preConfigure = ''
    # Performs and autoreconf
    export NOCONFIGURE="yes"
    patchShebangs bootstrap.sh
    ./bootstrap.sh

    # Move the udev rules under $(prefix).
    sed -i "src/Makefile.in" \
        -e "s|udevrulesdir[[:blank:]]*=.*$|udevrulesdir = $out/lib/udev/rules.d|g"

    # don't install proximity-helper as root and setuid
    sed -i "src/Makefile.in" \
        -e "s|chown root|true |" \
        -e "s|chmod r+s |true |"
  '';

  nativeBuildInputs = [
    pkgconfig
    intltool
    automake
    autoconf
    libtool
  ];

  propagatedBuildInputs = [
    optLibcap
  ];

  buildInputs = [
    json_c
    libsndfile
    gettext
    check
    database
    valgrind
    optOss
    optCoreaudio
    optAlsaLib
    optEsound
    optGlib
    optGtk3
    optGconf
    optAvahi
    optLibjack2
    optLibasyncns
    optLirc
    optDbus
    optUdev
    optOpenssl
    optFftw
    optSpeexdsp
    optSoxr
    optSystemd
    optWebrtc-audio-processing
  ] ++ optionals hasXlibs (with xorg; [
    libX11
    libxcb
    libICE
    libSM
    libXtst
    xextproto
    libXi
  ]) ++ optionals (optBluez != null) [
    optBluez
    optSbc
  ];

  installFlags = [
    "sysconfdir=$(out)/etc"
    "pulseconfdir=$(out)/etc/pulse"
  ];

  postInstall = optionalString libOnly ''
    rm -rf $out/{bin,share,etc,lib/{pulse-*,systemd}}
    sed 's|-lltdl|-L${libtool}/lib -lltdl|' -i $out/lib/libpulsecore-${version}.la
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Sound server for POSIX and Win32 systems";
    homepage = http://www.pulseaudio.org/;
    licenses = licenses.lgpl2Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}