{ kdeFramework, lib
, extra-cmake-modules
, attr
, ebook_tools
, exiv2
, ffmpeg
, karchive
, ki18n
, poppler_qt5
, qtbase
, taglib
}:

kdeFramework {
  name = "kfilemetadata";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ attr ebook_tools exiv2 ffmpeg karchive ki18n poppler_qt5 taglib ];
  propagatedBuildInputs = [ qtbase ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
