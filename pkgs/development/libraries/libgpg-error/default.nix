{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "libgpg-error-1.21";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha256 = "0kdq2cbnk84fr4jqcv689rlxpbyl6bda2cn6y3ll19v3mlydpnxp";
  };

  postPatch = ''
    sed '/BUILD_TIMESTAMP=/s/=.*/=1970-01-01T00:01+0000/' -i ./configure
  '';

  # If architecture-dependent MO files aren't available, they're generated
  # during build, so we need gettext for cross-builds.
  crossAttrs.buildInputs = [
    gettext
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Defines common error values for GnuPG components";
    homepage = https://www.gnupg.org/related_software/libgpg-error;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
