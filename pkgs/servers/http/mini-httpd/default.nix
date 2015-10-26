{ stdenv, fetchurl
, boost
}:

stdenv.mkDerivation rec {
  name = "mini-httpd-1.5";

  src = fetchurl {
    url = "mirror://savannah/mini-httpd/${name}.tar.gz";
    sha256 = "1x4b6x40ymbaamqqq9p97lc0mnah4q7bza04fjs35c8agpm19zir";
  };

  buildInputs = [
    boost
  ];

  enableParallelBuilding = true;

  # Fixes compat with boost 1.59
  # Please attempt removing when updating
  CPPFLAGS = "-DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED";

  meta = with stdenv.lib; {
    description = "A minimalistic high-performance web server";
    homepage = http://mini-httpd.nongnu.org/;
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
