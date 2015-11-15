{ stdenv, intltool, fetchurl, pkgconfig, gtkmm, libxml2
, bash, gtk3, glib, makeWrapper
, itstool, gnome3, librsvg, gdk_pixbuf, libgtop }:

stdenv.mkDerivation rec {
  name = "gnome-system-monitor-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${versionMajor}/${name}.tar.xz";
    sha256 = "0rp6wf5q19s8ikpww8j9hbbkv7l8yc3zw1qr627l8qm3xxm5sjly";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool libxml2
                  gtkmm libgtop makeWrapper
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings_desktop_schemas ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-system-monitor" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-system-monitor/3.12/;
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
