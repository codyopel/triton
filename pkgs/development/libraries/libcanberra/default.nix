{ stdenv, fetchurl
, libtool
, pkgconfig

, alsaLib
, gst_all_1
, gtk3
, libcap
, libpulseaudio
, libvorbis
, tdb
, udev
, xorg
}:

stdenv.mkDerivation rec {
  name = "libcanberra-0.30";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${name}.tar.xz";
    sha256 = "0wps39h8rx2b00vyvkia5j40fkak3dpipp1kzilqla0cgvk73dn2";
  };

  configureFlags = [
    "--enable-alsa"
    "--disable-oss"
    "--enable-pulse"
    "--enable-udev"
    "--enable-gstreamer"
    "--enable-null"
    "--disable-gtk"
    "--enable-gtk3"
    "--enable-tdb"
    "--disable-lynx"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
  ];

  nativeBuildInputs = [
    libtool
    pkgconfig
  ];

  buildInputs = [
    alsaLib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    libcap
    libpulseaudio
    libvorbis
    tdb
    udev
    xorg.libICE
    xorg.libSM
  ];

  postInstall = ''
    for f in $out/lib/*.la ; do
      sed 's|-lltdl|-L${libtool}/lib -lltdl|' -i $f
    done
  '';

  passthru = {
    gtkModule = "/lib/gtk-2.0/";
  };

  meta = with stdenv.lib; {
    description = "XDG Sound Theme and Name Specifications";
    homepage = http://0pointer.de/lennart/projects/libcanberra/;
    license = licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = platforms.gnu;  # arbitrary choice
  };
}