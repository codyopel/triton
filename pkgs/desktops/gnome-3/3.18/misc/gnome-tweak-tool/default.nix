{ stdenv, fetchurl
, intltool
, itstool
, makeWrapper
, pkgconfig

, python
, pygobject
, atk
, gtk3
, glib
, libsoup
, bash
, libxml2
, python3Packages
, gnome3
, librsvg
, gdk_pixbuf
, file
, libnotify
}:

stdenv.mkDerivation rec {
  name = "gnome-tweak-tool-${version}";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tweak-tool/${versionMajor}/${name}.tar.xz";
    sha256 = "0c4lw9fhflvpa5l5jsr70aqxcmvhdgh43ab35ly42j3n4c1i2b2w";
  };

  patches = [
    ./find_gsettings.patch
    #./0001-Search-for-themes-and-icons-in-system-data-dirs.patch
    #./0002-Don-t-show-multiple-entries-for-a-single-theme.patch
    ./0003-Create-config-dir-if-it-doesn-t-exist.patch
  ];

  makeFlags = [
    "DESTDIR=/"
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  nativeBuildInputs = [
    intltool
    itstool
    makeWrapper
    pkgconfig
  ];

  buildInputs = [
    gtk3
    glib
    libxml2
    gnome3.gsettings_desktop_schemas
    file
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    python
    pygobject
    libnotify
    gnome3.gnome_shell
    libsoup
    gnome3.gnome_settings_daemon
    gnome3.nautilus
    gnome3.gnome_desktop
  ];

  preFixup = ''
    gtk3AppsWrapperArgs+=("--prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath $out)")
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A tool to customize advanced GNOME 3 options";
    homepage = https://wiki.gnome.org/action/show/Apps/GnomeTweakTool;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
