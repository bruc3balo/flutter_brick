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
  static Color connectionStateColor(AsyncSnapshot snapshot) {
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
  static Widget showShimmer(AsyncSnapshot snapshot, Widget shimmerWidget, Widget widgetWithData, Widget onFailedToGetDataWidget, Widget noFutureWidget) {
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
  static ScrollBehavior getNoScrollBehaviour(BuildContext context) {
    return ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        dragDevices: PointerDeviceKind.values.toSet(),
        physics: const BouncingScrollPhysics());
  }
  static SpinKitDualRing getRingKit ({AsyncSnapshot? snapshot}) {
    return SpinKitDualRing(color: snapshot == null ? MyPalette.silver : MyPalette.connectionStateColor(snapshot));
  }
}

class MyThemes {

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

  static ValueNotifier<MyThemeModes> currentTheme = ValueNotifier(ThemeMode.system.name == ThemeMode.light.name ? MyThemeModes.light : MyThemeModes.dark);
}

enum MyThemeModes {

  light("Light"),
  dark("Dark");

  final String title;
  const MyThemeModes(this.title);

  ThemeData get data {
    switch(this) {
      case MyThemeModes.light:
        return MyThemes.lightTheme();
      case MyThemeModes.dark:
        return MyThemes.darkTheme();
    }
  }
}