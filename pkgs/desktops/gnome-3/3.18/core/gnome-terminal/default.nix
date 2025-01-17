{ stdenv, fetchurl, pkgconfig, cairo, libxml2, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, libuuid, vala
, desktop_file_utils, itstool, appdata-tools }:

stdenv.mkDerivation rec {
  name = "gnome-terminal-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${versionMajor}/${name}.tar.xz";
    sha256 = "1ylyv0mla2ypms7iyxndbdjvha0q9jzglb4mhfmqn9cm2gxc0day";
  };

  buildInputs = [ gnome3.gtk gnome3.gsettings_desktop_schemas gnome3.vte appdata-tools
                  gnome3.dconf itstool gnome3.nautilus vala ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which libuuid libxml2 desktop_file_utils ];

  # FIXME: enable for gnome3
  configureFlags = [ "--disable-search-provider" "--disable-migration" ];

  preFixup = ''
      gtk3AppsWrapperArgs+=("--prefix GIO_EXTRA_MODULES : ${gnome3.dconf}/lib/gio/modules")
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
