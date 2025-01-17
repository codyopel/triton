{ stdenv, fetchurl, python, buildPythonPackage, pythonPackages, pkgconfig
, pyrex096, ffmpeg, boost, glib, pygobject, gtk2, webkitgtk, libsoup, pygtk
, taglib, sqlite, pycurl, mutagen, pycairo, pythonDBus, pywebkitgtk
, libtorrentRasterbar, glib_networking, gsettings_desktop_schemas
, gst_python, gst_plugins_base, gst_plugins_good, gst_ffmpeg
, enableBonjour ? false, avahi ? null
}:

assert enableBonjour -> avahi != null;

with stdenv.lib;

buildPythonPackage rec {
  name = "miro-${version}";
  namePrefix = "";
  version = "6.0";

  src = fetchurl {
    url = "http://ftp.osuosl.org/pub/pculture.org/miro/src/${name}.tar.gz";
    sha256 = "0sq25w365i1fz95398vxql3yjl5i6mq77mnmlhmn0pgyg111k3am";
  };

  setSourceRoot = ''
    sourceRoot=${name}/linux
  '';

  patches = [ ./gconf.patch ];

  postPatch = ''
    patch -p1 -d .. < "${./youtube-feeds.patch}"

    sed -i -e 's/\$(shell which python)/python/' Makefile
    sed -i -e 's|/usr/bin/||' -e 's|/usr||' \
           -e 's/BUILD_TIME[^,]*/BUILD_TIME=0/' setup.py

    sed -i -e 's|default="/usr/bin/ffmpeg"|default="${ffmpeg}/bin/ffmpeg"|' \
      plat/options.py

    sed -i -e 's|/usr/share/miro/themes|'"$out/share/miro/themes"'|' \
           -e 's/gnome-open/xdg-open/g' \
           -e '/RESOURCE_ROOT =.*(/,/)/ {
                 c RESOURCE_ROOT = '"'$out/share/miro/resources/'"'
               }' \
           plat/resources.py
  '' + optionalString enableBonjour ''
    sed -i -e 's|ctypes.cdll.LoadLibrary( *|ctypes.CDLL("${avahi}/lib/" +|' \
      ../lib/libdaap/pybonjour.py
  '';

  # Disabled for now, because it requires networking and even if we skip those
  # tests, the whole test run takes around 10-20 minutes.
  doCheck = false;
  checkPhase = ''
    HOME="$TEMPDIR" LANG=en_US.UTF-8 python miro.real --unittest
  '';

  preInstall = ''
    # see https://bitbucket.org/pypa/setuptools/issue/130/install_data-doesnt-respect-prefix
    ${python}/bin/${python.executable} setup.py install_data --root=$out
    sed -i '/data_files=data_files/d' setup.py
  '';

  postInstall = ''
    mv "$out/bin/miro.real" "$out/bin/miro"
    wrapProgram "$out/bin/miro" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  buildInputs = [
    pkgconfig pyrex096 ffmpeg boost glib pygobject gtk2 webkitgtk libsoup
    pygtk taglib gsettings_desktop_schemas sqlite
  ];

  propagatedBuildInputs = [
    pygobject pygtk pycurl python.modules.sqlite3 mutagen pycairo pythonDBus
    pywebkitgtk libtorrentRasterbar
    gst_python gst_plugins_base gst_plugins_good gst_ffmpeg
  ] ++ optional enableBonjour avahi;

  meta = {
    homepage = "http://www.getmiro.com/";
    description = "Video and audio feed aggregator";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aszlig ];
    platforms = platforms.linux;
  };
}
