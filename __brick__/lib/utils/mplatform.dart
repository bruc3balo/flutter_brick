import 'package:flutter/foundation.dart';

enum Mplatform {
  android,
  web,
  ios,
  macos,
  windows,
  linux,
  fuchsia;

  static Mplatform get current {
    if(kIsWeb) {
      return Mplatform.web;
    } else {
      switch(defaultTargetPlatform) {
        case TargetPlatform.android:
          return Mplatform.android;
        case TargetPlatform.fuchsia:
          return Mplatform.fuchsia;
        case TargetPlatform.iOS:
          return Mplatform.ios;
        case TargetPlatform.linux:
          return Mplatform.linux;
        case TargetPlatform.macOS:
          return Mplatform.macos;
        case TargetPlatform.windows:
          return Mplatform.windows;
      }
    }
  }

  static bool isWeb () {
    return current == web;
  }

  static bool isAndroid () {
    return current ==android;
  }

  static bool isIos () {
    return current == ios;
  }

  static bool isMacOs() {
    return current == macos;
  }

  static bool isWindows () {
    return current == windows;
  }

  static bool isLinux () {
    return current == linux;
  }

  static bool isFuchsia () {
    return current == fuchsia;
  }

}
