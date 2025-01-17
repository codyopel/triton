{ stdenv, fetchurl, pkgconfig, glib, gnome3, libxml2
, libsoup, json_glib, gmp, openssl }:

let
  majVer = "3.14";
in stdenv.mkDerivation rec {
  name = "gnome-online-miners-${majVer}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-miners/${majVer}/${name}.tar.xz";
    sha256 = "0bbak8srcrvnw18s4ls5mqaamx9nqdi93lij6yjs0a3q320k22xl";
  };

  doCheck = true;

  buildInputs = [ pkgconfig glib gnome3.libgdata libxml2 libsoup gmp openssl
                  gnome3.grilo gnome3.libzapojit gnome3.grilo-plugins
                  gnome3.gnome_online_accounts gnome3.libmediaart
                  gnome3.tracker gnome3.gfbgraph json_glib gnome3.rest ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeOnlineMiners;
    description = "A set of crawlers that go through your online content and index them locally in Tracker";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
