{stdenv, version}:

{
  inherit version;

  name = "cargo-${version}";

  postInstall = ''
    rm "$out/lib/rustlib/components" \
       "$out/lib/rustlib/install.log" \
       "$out/lib/rustlib/rust-installer-version" \
       "$out/lib/rustlib/uninstall.sh" \
       "$out/lib/rustlib/manifest-cargo"
  '';

  platform = if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else throw "no snapshot to bootstrap for this platform (missing platform url suffix)";

  meta = with stdenv.lib; {
    homepage = http://crates.io;
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = with maintainers; [ wizeman ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux;
  };
}
