{ fetchurl, stdenv, pkgconfig, gtk, gettext, bzip2, zlib
, libjpeg, libtiff, cfitsio, exiv2, lcms, gtkimageview, lensfun }:

stdenv.mkDerivation rec {
  name = "ufraw-0.20";

  src = fetchurl {
    # XXX: These guys appear to mutate uploaded tarballs!
    url = "mirror://sourceforge/ufraw/${name}.tar.gz";
    sha256 = "1q51p0ynzayxwfpilj0s38aapgkfga00gbl7xi0ndx9q6bvk1kbd";
  };

  buildInputs =
    [ pkgconfig gtk gtkimageview gettext bzip2 zlib
      libjpeg libtiff cfitsio exiv2 lcms lensfun
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://ufraw.sourceforge.net/;

    description = "Utility to read and manipulate raw images from digital cameras";

    longDescription =
      '' The Unidentified Flying Raw (UFRaw) is a utility to read and
         manipulate raw images from digital cameras.  It can be used on its
         own or as a Gimp plug-in.  It reads raw images using Dave Coffin's
         raw conversion utility - DCRaw.  UFRaw supports color management
         workflow based on Little CMS, allowing the user to apply ICC color
         profiles.  For Nikon users UFRaw has the advantage that it can read
         the camera's tone curves.
      '';

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # needs GTK+
  };
}
