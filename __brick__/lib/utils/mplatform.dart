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
}

extension MplaformExtension on Mplatform {

  bool get isWeb {
    return Mplatform.current == Mplatform.web;
  }

  bool get isAndroid {
    return Mplatform.current == Mplatform.android;
  }

  bool get isIos {
    return Mplatform.current == Mplatform.ios;
  }

  bool get isMacOs{
    return Mplatform.current == Mplatform.macos;
  }

  bool get isWindows {
    return Mplatform.current == Mplatform.windows;
  }

  bool get isLinux {
    return Mplatform.current == Mplatform.linux;
  }

  bool get isFuchsia {
    return Mplatform.current == Mplatform.fuchsia;
  }
}