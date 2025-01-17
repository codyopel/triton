{ stdenv, fetchurl
, rpmextract
, glibc
# Plex's data directory must be baked into the package due to symlinks.
, dataDir ? "/var/lib/plex"
}:

stdenv.mkDerivation rec {
  name = "plex-${version}";
  version = "0.9.11.13.1464";
  vsnHash = "4ccd2ca";

  src = fetchurl {
    url = "https://downloads.plex.tv/plex-media-server/${version}-${vsnHash}/plexmediaserver-${version}-${vsnHash}.x86_64.rpm";
    sha256 = "1gzq3ik3b23pl6i85d4abh3aqq710z5x258mjm7xai8rpyhvdp26";
  };

  phases = [
    "unpackPhase"
    "installPhase"
    "fixupPhase"
    "distPhase"
  ];

  unpackPhase = ''
    rpmextract $src
  '';

  buildInputs = [
    rpmextract
    glibc
  ];

  installPhase = ''
    install -d $out/usr/lib
    cp -dr --no-preserve='ownership' usr/lib/plexmediaserver $out/usr/lib/

    # Now we need to patch up the executables and libraries to work on Nix.
    # Side note: PLEASE don't put spaces in your binary names. This is stupid.
    for bin in "Plex Media Server" "Plex DLNA Server" "Plex Media Scanner"; do
      patchelf --set-interpreter "${glibc}/lib/ld-linux-x86-64.so.2" "$out/usr/lib/plexmediaserver/$bin"
      patchelf --set-rpath "$out/usr/lib/plexmediaserver" "$out/usr/lib/plexmediaserver/$bin"
    done

    find $out/usr/lib/plexmediaserver/Resources -type f -a -perm -0100 \
        -print -exec patchelf --set-interpreter "${glibc}/lib/ld-linux-x86-64.so.2" '{}' \;


    # Our next problem is the "Resources" directory in /usr/lib/plexmediaserver.
    # This is ostensibly a skeleton directory, which contains files that Plex
    # copies into its folder in /var. Unfortunately, there are some SQLite
    # databases in the directory that are opened at startup. Since these
    # database files are read-only, SQLite chokes and Plex fails to start. To
    # solve this, we keep the resources directory in the Nix store, but we
    # rename the database files and replace the originals with symlinks to
    # /var/lib/plex. Then, in the systemd unit, the base database files are
    # copied to /var/lib/plex before starting Plex.
    RSC=$out/usr/lib/plexmediaserver/Resources
    for db in "com.plexapp.plugins.library.db"; do
        mv $RSC/$db $RSC/base_$db
        ln -s ${dataDir}/.skeleton/$db $RSC/$db
    done
  '';

  meta = with stdenv.lib; {
    description = "Media / DLNA server";
    homepage = http://plex.tv/;
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
