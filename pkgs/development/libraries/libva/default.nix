{ stdenv, fetchurl
, pkgconfig

, libdrm
, libffi
, wayland
, xorg
}:

stdenv.mkDerivation rec {
  name = "libva-1.6.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "0bjfb5s8dk3lql843l91ffxzlq47isqks5sj19cxh7j3nhzw58kz";
  };

  configureFlags = [
    "--disable-docs"
    "--enable-drm"
    "--enable-x11"
    "--enable-glx"
    "--enable-egl"
    "--enable-wayland"
    #"--enable-dummy-driver"
    #"--with-drivers-path"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libdrm
    libffi
    wayland
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
  ];

  meta = with stdenv.lib; {
    description = "Video Acceleration API (VAAPI)";
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
