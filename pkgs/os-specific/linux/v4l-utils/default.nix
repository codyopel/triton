{ stdenv, fetchurl
, pkgconfig
# Required
, libjpeg
# Optional
, alsaLib
, qt5
, xorg

, config ? "lib"
}:

# See libv4l in all-packages.nix for the libs only (overrides alsa, libX11 & QT)

with {
  inherit (stdenv.lib)
    enFlag
    optionals
    wtFlag;
};

assert (config == "lib" || config == "utils");
assert config == "utils" ->
  alsaLib != null &&
  xorg != null &&
  qt5 != null;
assert qt5 != null -> qt5.base != null;
assert xorg != null -> xorg.libX11 != null;

let
  prefix =
    if config == "lib" then
      "lib"
    else
      "";
  suffix =
    if config == "utils" then
      "-utils"
    else
      "";
in

stdenv.mkDerivation rec {
  name = "${prefix}v4l${suffix}-${version}";
  version = "1.8.1";

  src = fetchurl {
    url = "http://linuxtv.org/downloads/v4l-utils/v4l-utils-${version}.tar.bz2";
    sha256 = "0cqv8drw0z0kfmz4f50a8kzbrz6vbj6j6q78030hgshr7yq1jqig";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-rpath"
    (enFlag "libdvbv5" (config == "utils") null)
    "--enable-libv4l"
    (enFlag "v4l-utils" (config == "utils") null)
    "--disable-v4l2-compliance-libv4l"
    "--disable-v4l2-ctl-libv4l"
    (enFlag "qv4l2" (config == "utils") null)
    "--disable-gconv"
    "--with-jpeg"
    (wtFlag "libudev" (config == "utils") null)
    (wtFlag "udevdir" (config == "utils") "\${out}/lib/udev")
  ];

  nativeBuildInputs = [
    pkgconfig
  ];
  
  propagatedBuildInputs = [
    libjpeg
  ];

  buildInputs = optionals (config == "utils") [
    alsaLib
    qt5.base
    xorg.libX11
  ];

  postInstall = ''
    # Create symlinks for v4l1 compatibility
    ln -sv $out/include/libv4l1-videodev.h $out/include/videodev.h
    mkdir -pv $out/include/linux
    ln -sv $out/include/libv4l1-videodev.h $out/include/linux/videodev.h
  '';

  meta = with stdenv.lib; {
    description = "Provides common image formats regardless of the v4l device";
    homepage = http://linuxtv.org/projects.php;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
