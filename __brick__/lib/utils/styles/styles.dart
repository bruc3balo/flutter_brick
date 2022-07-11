import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class MyPalette {
  static Color get silver => HexColor("#C0C0C0");
  static Color get grey => Colors.grey;
  static Color get black => Colors.black;
  static Color get red => Colors.red;
  static Color get green => Colors.green;
  static Color get blue => Colors.blue;
  static Color get white => Colors.white;
  static Color connectionStateColor({required AsyncSnapshot snapshot}) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return grey;
      case ConnectionState.waiting:
        return snapshot.hasError ? red : black;
      case ConnectionState.active:
        return green;
      case ConnectionState.done:
        return blue;
    }
  }
}
class MyWidgets {
  static LinearGradient shimmerGradient =  LinearGradient(
      colors: [MyPalette.grey, MyPalette.silver, MyPalette.black,],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: const [0.0, 0.5, 1.0],
      tileMode: TileMode.mirror,
      transform: const GradientRotation(0.7853982)
  );
  static Widget showShimmer({required AsyncSnapshot snapshot, required Widget shimmerWidget, required Widget widgetWithData, required Widget onFailedToGetDataWidget, required Widget noFutureWidget}) {
    switch(snapshot.connectionState) {
      case ConnectionState.none:
        return noFutureWidget;
      case ConnectionState.waiting:
      case ConnectionState.active:
        if(snapshot.hasData) {
          return widgetWithData;
        } else {
          return Center(
            child: Shimmer(
              gradient: shimmerGradient,
              child: shimmerWidget,
            ),
          );
        }
      case ConnectionState.done:
        if(snapshot.hasData) {
          return widgetWithData;
        } else {
          return onFailedToGetDataWidget;
        }
    }
  }
  static ScrollBehavior getNoScrollBehaviour(BuildContext context,{ScrollPhysics? physics}) {
    return ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        dragDevices: PointerDeviceKind.values.toSet(),
        physics: physics ?? const BouncingScrollPhysics());
  }
  static SpinKitDualRing getRingKit ({AsyncSnapshot? snapshot}) {
    return SpinKitDualRing(color: snapshot == null ? MyPalette.silver : MyPalette.connectionStateColor(snapshot: snapshot));
  }
}

class MyThemes extends ValueNotifier<MyThemeModes> {

  MyThemes() : super(ThemeMode.system.name == ThemeMode.light.name ? MyThemeModes.light : MyThemeModes.dark);

  MyThemeModes get current => value;
  bool get isDarkMode => value == MyThemeModes.dark;
  bool get isLightMode => value == MyThemeModes.light;

  void changeTheme({required MyThemeModes themeMode}) {
    value = themeMode;
  }

}
enum MyThemeModes {
  //themes not restricted to light mode and dark mode
  //default is system theme though

  light("Light"),
  dark("Dark");

  final String title;
  const MyThemeModes(this.title);

  ThemeData get data {
    switch(this) {
      case MyThemeModes.light:
        return lightTheme();
      case MyThemeModes.dark:
        return darkTheme();
    }
  }

  static ThemeData lightTheme () {
    return ThemeData(
        scaffoldBackgroundColor: MyPalette.white
    );
  }

  static ThemeData darkTheme () {
    return ThemeData(
        scaffoldBackgroundColor: MyPalette.black
    );
  }

}

class ScreenSize extends ValueNotifier<Size> {

  ScreenSize() : super(Size(0.0, 0.0));

  Size get currentMax => value;

  bool get isMobile => ScreenSizeEnums.isMobile(value.width);
  bool get isTablet => ScreenSizeEnums.isTablet(value.width);
  bool get isUnsupported => ScreenSizeEnums.isUnsupported(value.width);
  bool get isDesktop => ScreenSizeEnums.isDesktop(value.width);

  ScreenSizeEnums get currentSize => ScreenSizeEnums.current(value.width);

  void updateSize ({required double width, required double height}) {
    debugPrint("Size is updating");
    value = Size(width, height);
    debugPrint("Width is ${value.width}");
  }

}

enum ScreenSizeEnums {
  unsupported(0),
  //todo set minimum supported size
  mobile(320.0),
  tablet(716.0),
  desktop(1025.0);

  final double minWidth;

  const ScreenSizeEnums(this.minWidth);

  static ScreenSizeEnums getFromWidth (double width) {
    if(isMobile(width)) {
      return mobile;
    } else if(isTablet(width)) {
      return tablet;
    } else if(isDesktop(width)) {
      return desktop;
    } else {
      return unsupported;
    }
  }

  static bool isUnsupported (double width) {
    return width < mobile.minWidth;
  }

  static bool isMobile (double width) {
    return width >= mobile.minWidth && width < tablet.minWidth;
  }

  static bool isTablet (double width) {
    return width >= tablet.minWidth && width < desktop.minWidth;
  }

  static bool isDesktop (double width) {
    return width >= desktop.minWidth;
  }

  static ScreenSizeEnums current(double width) {
    return getFromWidth(width);
  }

}

//todo use your preferred provider
MyThemes themeProvider = MyThemes();
ScreenSize screenSizeProvider = ScreenSize();

