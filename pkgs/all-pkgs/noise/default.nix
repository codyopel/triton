{ stdenv, fetchurl
, cmake
, gettext
, pkgconfig

, glib
, gobjectIntrospection
, gnome3
, granite
, gst_all_1
, gtk3
, json_glib
#, libdbusmenu
#, libgee
, libgpod
#, libindicate
, libnotify
#, libpeas
, librsvg
, libsoup
, libxml2
, sqlheavy
, taglib
, vala
, zeitgeist
}:

with {
  inherit (stdenv.lib)
    makeSearchPath;
};

stdenv.mkDerivation rec {
  name = "noise-${version}";
  versionMajor = "0.3";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "https://launchpad.net/noise/${versionMajor}.x/${version}/" +
          "+download/${name}.tgz";
    sha256 = "07hfdrjbqq683f3lp0yiysx7vmvszsghh97dafdyajwls1clcp14";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DGSETTINGS_COMPILE=ON"
  ];

  nativeBuildInputs = [
    cmake
    gettext
    pkgconfig
  ];

  buildInputs = [
    glib
    gobjectIntrospection
    granite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtk3
    json_glib
    #libdbusmenu
    gnome3.libgee
    libgpod
    #libindicate
    libnotify
    gnome3.libpeas
    librsvg
    libsoup
    libxml2
    sqlheavy
    taglib
    vala
    zeitgeist
  ];

  preFixup = ''
    gtk3AppsWrapperArgs+=(
      "--prefix GST_PLUGIN_PATH : ${
        makeSearchPath "lib/gstreamer-0.10" [
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
        ]}"
    )
  '';

  meta = with stdenv.lib; {
    description = "Music player for Elementary OS";
    homepage = https://launchpad.net/noise;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}