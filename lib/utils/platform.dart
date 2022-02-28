import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

//ignore: avoid_classes_with_only_static_members
class PlatformType {
  static PlatformTypeEnum currentPlatformType = _getCurrentPlatformType();

  static PlatformTypeEnum _getCurrentPlatformType() {
    if (kIsWeb) {
      return PlatformTypeEnum.web;
    } else if (Platform.isIOS || Platform.isMacOS) {
      return PlatformTypeEnum.cupertino;
    } else if (Platform.isWindows || Platform.isLinux) {
      return PlatformTypeEnum.fluent;
    } else {
      return PlatformTypeEnum.material;
    }
  }

  static bool isCupertino() {
    return currentPlatformType == PlatformTypeEnum.cupertino;
  }

  static bool isFluent() {
    return currentPlatformType == PlatformTypeEnum.fluent;
  }

  static bool isMaterial() {
    return currentPlatformType == PlatformTypeEnum.material ||
        currentPlatformType == PlatformTypeEnum.web;
  }
}

enum PlatformTypeEnum { cupertino, material, fluent, web }
