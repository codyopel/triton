{ stdenv, fetchurl, fetchpatch
, libxslt
, pkgconfig
, substituteAll

, freetype
, expat
, fontbhttf
}:

/** Font configuration scheme
 - ./config-compat.patch makes fontconfig try the following root configs, in order:
    $FONTCONFIG_FILE, /etc/fonts/${configVersion}/fonts.conf, /etc/fonts/fonts.conf
    This is done not to override config of pre-2.11 versions (which just blow up)
    and still use *global* font configuration at both NixOS or non-NixOS.
 - NixOS creates /etc/fonts/${configVersion}/fonts.conf link to $out/etc/fonts/fonts.conf,
    and other modifications should go to /etc/fonts/${configVersion}/conf.d
 - See ./make-fonts-conf.xsl for config details.

*/

let
  # bump whenever fontconfig breaks compatibility with older configurations
  configVersion = "2.11";
in

stdenv.mkDerivation rec {
  name = "fontconfig-2.11.1";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.bz2";
    sha256 = "16baa4g5lswkyjlyf1h5lwc0zjap7c4d8grw79349a5w6dsl8qnw";
  };

  # We should find a better way to access the arch reliably.
  crossArch = stdenv.cross.arch or null;

  patches = [
    (fetchpatch {
        url = "http://cgit.freedesktop.org/fontconfig/patch/?id=f44157c809d280e2a0ce87fb078fc4b278d24a67";
        sha256 = "19s5irclg4irj2yxd7xw9yikbazs9263px8qbv4r21asw06nfalv";
        name = "fc-cache-bug-77252.patch";
    })
    (substituteAll {
      src = ./config-compat.patch;
      inherit configVersion;
    })
  ];

  configureFlags = [
    "--enable-largefile"
    "--disable-iconv"
    "--disable-libxml2"
    "--disable-docs"
    "--with-cache-dir=/var/cache/fontconfig" # otherwise the fallback is in $out/
    "--with-default-fonts=${fontbhttf}"
  ];

  preConfigure = ''
    if test -n "$crossConfig" ; then
      configureFlagsArray+=("--with-arch=$crossArch");
    fi
  '';

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    expat
  ];

  propagatedBuildInputs = [
    freetype
  ];

  # Don't try to write to /var/cache/fontconfig at install time.
  installFlags = [
    "fc_cachedir=$(TMPDIR)/dummy"
    "RUN_FC_CACHE_TEST=false"
  ];

  postInstall = ''
    cd "$out/etc/fonts"
    rm conf.d/{50-user,51-local}.conf
    "${libxslt}/bin/xsltproc" \
      --stringparam fontDirectories "${fontbhttf}" \
      --stringparam fontconfig "$out" \
      --stringparam fontconfigConfigVersion "${configVersion}" \
      --path $out/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} $out/etc/fonts/fonts.conf \
      > fonts.conf.tmp
    mv fonts.conf.tmp $out/etc/fonts/fonts.conf
  '';

  doCheck = true;
  enableParallelBuilding = true;

  passthru = {
    inherit configVersion;
  };

  meta = with stdenv.lib; {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.all;
  };
}

