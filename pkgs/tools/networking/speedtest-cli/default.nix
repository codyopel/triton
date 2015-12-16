{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "speedtest-cli-0.3.4";
  namePrefix = "";
  
  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/speedtest-cli/" +
          "${name}.tar.gz";
    sha256 = "19i671cd815fcv0x7h2m0a493slzwkzn7r926g8myx1srkss0q6d";
  };

  meta = with stdenv.lib; {
    description = "CLI for testing internet bandwidth using speedtest.net";
    homepage = https://github.com/sivel/speedtest-cli;
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
