{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.8";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "03y6z8akj72swa6f42h2dhq3p09xasbi6xia70h2vc27fwikmny6";
  };

  meta = {
    description = "A POSIX-compliant implementation of /bin/sh";
    homepage = http://gondor.apana.org.au/~herbert/dash/;
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
