{ stdenv, fetchurl
, pkgconfig
, python2
, python3

, jansson
, plugins
, withPAM ? stdenv.isLinux, pam
, withSystemd ? stdenv.isLinux, systemd
, ncurses
}:

with {
  inherit (stdenv.lib)
    all
    any
    concatMap
    concatStringsSep
    optional;
};

let
  pythonPlugin =
    pkg: {
      name = "python${if pkg ? isPy2 then "2" else "3"}";
      interpreter = pkg;
      path = "plugins/python";
      deps = [ pkg ncurses ];
      install = ''
        install -Dm644 uwsgidecorators.py $out/${pkg.sitePackages}/uwsgidecorators.py
        ${pkg.executable} -m compileall $out/${pkg.sitePackages}/
        ${pkg.executable} -O -m compileall $out/${pkg.sitePackages}/
      '';
    };
  available = [
    (pythonPlugin python2)
    (pythonPlugin python3)
  ];
  needed = builtins.filter (x: any (y: x.name == y) plugins) available;
in

assert builtins.filter (x: all (y: y.name != x) available) plugins == [];

stdenv.mkDerivation rec {
  name = "uwsgi-2.0.11.2";

  src = fetchurl {
    url = "http://projects.unbit.it/downloads/${name}.tar.gz";
    sha256 = "0p482j4yi48bmpgx1qpdfk86hjn4dswb137jbmigdlrd9l5rp20b";
  };

  configurePhase = ''
    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini
  '';

  nativeBuildInputs = [
    pkgconfig
    python3
  ];

  buildInputs = [
    jansson
  ] ++ optional withPAM pam
    ++ optional withSystemd systemd
    ++ concatMap (x: x.deps) needed;

  basePlugins = concatStringsSep "," (
    optional withPAM "pam" ++
    optional withSystemd "systemd_logger"
  );

  buildPhase = ''
    mkdir -p $pluginDir
    python3 uwsgiconfig.py --build nixos
    ${lib.concatMapStringsSep ";" (x: "${x.interpreter.interpreter} uwsgiconfig.py --plugin ${x.path} nixos ${x.name}") needed}
  '';

  installPhase = ''
    install -Dm755 uwsgi $out/bin/uwsgi
    #cp *_plugin.so $pluginDir || true
    ${lib.concatMapStringsSep "\n" (x: x.install) needed}
  '';

  passthru = {
    inherit
      python2
      python3;
  };

  meta = with stdenv.lib; {
    description = "Application container server";
    homepage = http://uwsgi-docs.readthedocs.org/en/latest/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
