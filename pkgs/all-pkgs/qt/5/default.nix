{ pkgs }:

let
  pkgsFun =
    overrides:
    let 
      self = self_ // overrides;
      self_ = with self; {
        overridePackages =
          f:
          let
            newself = pkgsFun (f newself self);
          in
          newself;

        callPackage = pkgs.newScope self;

        #qt3d = callPackage submodules/qt3d { };

        qt5 = callPackage submodules/qt5 { };

        qtactiveqt =  callPackage submodules/qtactiveqt { };

        qtandroidextras =  callPackage submodules/qtandroidextras { };

        qtbase =  callPackage submodules/qtbase { };

        qtcanvas3d =  callPackage submodules/qtcanvas3d { };

        qtconnectivity =  callPackage submodules/qtconnectivity { };

        qtdeclarative =  callPackage submodules/qtdeclarative { };

        qtdoc =  callPackage submodules/qtdoc { };

        qtenginio =  callPackage submodules/qtenginio { };

        qtgraphicaleffects =  callPackage submodules/qtgraphicaleffects { };

        qtimageformats =  callPackage submodules/qtimageformats { };

        qtlocation =  callPackage submodules/qtlocation { };

        qtmacextras =  callPackage submodules/qtmacextras { };

        qtmultimedia =  callPackage submodules/qtmultimedia { };

        qtquick1 =  callPackage submodules/qtquick1 { };

        qtquickcontrols =  callPackage submodules/qtquickcontrols { };

        qtscript =  callPackage submodules/qtscript { };

        qtserialport =  callPackage submodules/qtserialport { };

        qtsvg =  callPackage submodules/qtsvg { };

        qttools =  callPackage submodules/qttools { };

        qttranslations =  callPackage submodules/qttranslations { };

        qtwayland =  callPackage submodules/qtwayland { };

        qtwebchannel =  callPackage submodules/qtwebchannel { };

        qtwebengine =  callPackage submodules/qtwebengine { };

        qtwebkit =  callPackage submodules/qtwebkit { };

        qtwebsockets =  callPackage submodules/qtwebsockets { };

        qtwinextras =  callPackage submodules/qtwinextras { };

        qtx11extras =  callPackage submodules/qtx11extras { };

        qtxmlpatterns =  callPackage submodules/qtxmlpatterns { };
      };
    in
    self; # pkgsFun
in
pkgsFun { }
