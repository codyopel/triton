{ stdenv, fetchurl, fetchpatch
, autoreconfHook
, bison
, flex
, intltool
, makedepend
, pkgconfig
, python
, pythonPackages
, substituteAll

, libxml2Python

, expat
, file
, libclc
, libdrm
, libelf
, libffi
, libomxil-bellagio
, libva
, libvdpau
, llvmPackages
, udev
, wayland
, xorg

, grsecEnabled
# Texture floats are patented, see docs/patents.txt
, enableTextureFloats ? false
}:

with {
  inherit (stdenv.lib)
    enFlag
    optional
    optionals
    optionalString;
};

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "Mesa does not support the `${stdenv.system}` platform"
else

/** Packaging design:
  - The basic mesa ($out) contains headers and libraries (GLU is in mesa_glu now).
    This or the mesa attribute (which also contains GLU) are small (~ 2 MB, mostly headers)
    and are designed to be the buildInput of other packages.
  - DRI drivers are compiled into $drivers output, which is much bigger and
    depends on LLVM. These should be searched at runtime in
    "/run/opengl-driver{,-32}/lib/*" and so are kind-of impure (given by NixOS).
    (I suppose on non-NixOS one would create the appropriate symlinks from there.)
  - libOSMesa is in $osmesa (~4 MB)
*/

let
  version = "11.1.0";
  # this is the default search path for DRI drivers
  driverLink = "/run/opengl-driver" + optionalString stdenv.isi686 "-32";
  clang =
    if llvmPackages ? clang-unwrapped then
      llvmPackages.clang-unwrapped
    else
      llvmPackages.clang;
in

stdenv.mkDerivation {
  name = "mesa-noglu-${version}";

  src =  fetchurl {
    urls = [
      "https://launchpad.net/mesa/trunk/${version}/+download/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
    ];
    sha256 = "9befe03b04223eb1ede177fa8cac001e2850292c8c12a3ec9929106afad9cf1f";
  };

  patches = [
    # fix for grsecurity/PaX
    ./glx_ro_text_segm.patch
  ] ++ optional stdenv.isLinux (
    substituteAll {
      src = ./dlopen-absolute-paths.diff;
      inherit udev;
    }
  );

  postPatch = ''
    patchShebangs .

    substituteInPlace src/egl/main/egldriver.c \
      --replace _EGL_DRIVER_SEARCH_DIR '"${driverLink}"'
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-largefile"
    "--disable-debug"
    # slight performance degradation, enable only for grsec
    (enFlag "glx-rts" grsecEnabled null)
    "--disable-mangling"
    (enFlag "texture-float" enableTextureFloats null)
    "--enable-asm"
    # TODO: add selinux support
    "--disable-selinux"
    "--enable-opengl"
    "--enable-gles1"
    "--enable-gles2"
    "--enable-dri"
    "--enable-dri3"
    "--enable-glx"
    "--disable-osmesa"
    "--enable-gallium-osmesa" # used by wine
    "--enable-egl"
    "--enable-xa" # used in vmware driver
    "--enable-gbm"
    "--enable-nine" # Direct3D in Wine
    "--enable-xvmc"
    "--enable-vdpau"
    "--enable-omx"
    "--enable-va"
    # TODO: Figure out how to enable opencl without having a
    #       runtime dependency on clang
    # FIXME: fix opencl
    #        llvm/invocation.cpp:25:45: fatal error: \
    #        clang/Frontend/CompilerInstance.h: No such file
    "--disable-opencl"
    "--disable-opencl-icd"
    "--disable-xlib-glx"
    "--disable-r600-llvm-compiler"
    "--disable-gallium-tests"
    "--enable-shared-glapi"
    "--enable-sysfs"
    "--enable-driglx-direct" # seems enabled anyway
    "--enable-glx-tls"
    "--disable-glx-read-only-text"
    "--enable-gallium-llvm"
    "--enable-llvm-shared-libs"

    #gl-lib-name=GL
    #osmesa-libname=OSMesa
    "--with-gallium-drivers=svga,i915,ilo,r300,r600,radeonsi,nouveau,freedreno,swrast"
    "--with-dri-driverdir=$(drivers)/lib/dri"
    "--with-dri-searchpath=${driverLink}/lib/dri"
    "--with-dri-drivers=i915,i965,nouveau,radeon,r200,swrast"
    #osmesa-bits=8
    #"--with-clang-libdir=${clang}/lib"
    "--with-egl-platforms=x11,wayland,drm"
    #llvm-prefix
    #xvmc-libdir
    #vdpau-libdir
    #omx-libdir
    #va-libdir
    #d3d-libdir
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    file
    flex
    intltool
    makedepend
    pkgconfig
    python
    pythonPackages.Mako
  ];

  propagatedBuildInputs = [
    wayland
  ];

  buildInputs = [
    expat
    libclc
    libdrm
    libelf
    libffi
    libomxil-bellagio
    libva
    libvdpau
    #libxml2Python
    llvmPackages.llvm
    udev
    xorg.dri2proto
    xorg.dri3proto
    xorg.glproto
    xorg.libX11
    xorg.libxcb
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libxshmfence
    xorg.libXt
    xorg.libXvMC
    xorg.libXxf86vm
    xorg.presentproto
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM;
  #   also move libOSMesa to $osmesa, as it's relatively big
  # ToDo: probably not all .la files are completely fixed, but it shouldn't matter
  postInstall = ''
    mv -t "$drivers/lib/" \
      $out/lib/libXvMC* \
      $out/lib/d3d \
      $out/lib/vdpau \
      $out/lib/libxatracker*

    mkdir -p {$osmesa,$drivers}/lib/pkgconfig
    mv -t $osmesa/lib/ \
      $out/lib/libOSMesa*

    mv -t $drivers/lib/pkgconfig/ \
      $out/lib/pkgconfig/xatracker.pc

    mv -t $osmesa/lib/pkgconfig/ \
      $out/lib/pkgconfig/osmesa.pc

  '' + /* fix references in .la files */ ''
    sed "/^libdir=/s,$out,$osmesa," -i \
      $osmesa/lib/libOSMesa*.la

  '' + /* work around bug #529, but maybe $drivers should also be patchelf'd */ ''
    find $drivers/ $osmesa/ -type f -executable -print0 | xargs -0 strip -S || true

  '' + /* add RPATH so the drivers can find the moved libgallium and libdricore9 */ ''
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '' + /* set the default search path for DRI drivers; used e.g. by X server */ ''
    substituteInPlace "$out/lib/pkgconfig/dri.pc" --replace '$(drivers)' "${driverLink}"
  '' + /* move vdpau drivers to $drivers/lib, so they are found */ ''
    mv "$drivers"/lib/vdpau/* "$drivers"/lib/ && rmdir "$drivers"/lib/vdpau
  '';

  outputs = [ "out" "drivers" "osmesa" ];

  doCheck = false;
  enableParallelBuilding = true;

  passthru = {
    inherit
      libdrm
      version
      driverLink;
  };

  meta = with stdenv.lib; {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.mesaPlatforms;
  };
}
