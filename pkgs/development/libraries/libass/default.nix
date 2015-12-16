{ stdenv, fetchurl
, pkgconfig
, yasm

, enca
, fontconfig
, freetype
, fribidi
, harfbuzz

# Internal rasterizer
, rasterizerSupport ? false
# Use larger tiles in the rasterizer
, largeTilesSupport ? false
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "libass-${version}";
  version = "0.13.1";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/" +
          "${name}.tar.xz";
    sha256 = "1rrz6is2blx8jqyydcz71y2f5f948blgx14jzi3an756fqc6p8sa";
  };

  configureFlags = [
    "--disable-test"
    "--disable-profile"
    "--enable-fontconfig"
    "--disable-directwrite"
    "--disable-coretext"
    "--enable-require-system-font-provider"
    "--enable-harfbuzz"
    "--enable-asm"
    (enFlag "rasterizer" rasterizerSupport null)
    (enFlag "large-tiles" largeTilesSupport null)
  ];

  nativeBuildInputs = [
    pkgconfig
    yasm
  ];

  buildInputs = [
    fontconfig
    freetype
    fribidi
    harfbuzz
  ];

  meta = with stdenv.lib; {
    description = "Portable ASS/SSA subtitle renderer";
    homepage = https://github.com/libass/libass;
    license = licenses.isc;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
