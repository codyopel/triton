{ stdenv, fetchurl
, pkgconfig

, glib
, gobjectIntrospection
, gssdp
, libsoup
, libuuid
, libxml2
}:

with {
  inherit (stdenv.lib)
    enFlag;
};
 
stdenv.mkDerivation rec {
  name = "gupnp-${version}";
  versionMajor = "0.20";
  versionMinor = "14";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${versionMajor}/${name}.tar.xz";
    sha256 = "1garmpcxniy8q55ci1nyrcnnb4jxqw211m09dm1adi3pp90bkzvp";
  };

  configureFlags = [
    "--enable-largefile"
    "--disable-debug"
    (enFlag "introspection" (gobjectIntrospection != null) "yes")
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    #--with-context-manager=[network-manager/connman/unix/linux]
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
    gobjectIntrospection
    gssdp
    libsoup
    libxml2
    libuuid
  ];

  postInstall = ''
    ln -sv ${libsoup}/include/libsoup-[0-9].[0-9]/libsoup $out/include
    ln -sv ${libxml2}/include/*/libxml $out/include
    ln -sv ${gssdp}/include/*/libgssdp $out/include
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.gupnp.org/;
    description = "An implementation of the UPnP specification";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
