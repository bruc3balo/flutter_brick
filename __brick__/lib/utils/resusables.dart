import 'dart:ui';

import 'package:bruce_brick/utils/mplatform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:shimmer/shimmer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class MyVariables {
  //const
  static const String appName = "Brick";
  static const double fieldHeight = 50.0;
  static const double fieldWidth = 300.0;
  static const String unknown = "404";
  static const String unknownRoute = "/404";
  static const String splashScreenRoute = "/";
  static const String splashScreen = "Splash";
  static const Duration transitionDuration = Duration(milliseconds: 1500);

  //non-const
  static bool mobileView = false;
  static double screenHeight = 0.0;
  static double screenWidth = 0.0;
  static const double mobileSize = 900; //715

}

class MyMethods {
  //void
  static void killApp() {
    if (Mplatform.current.isWeb) {
      if(html.window.closed != null) {
        if(html.window.closed!) {
          html.window.close;
        }
      }
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }

  //date
  static DateTime getMyDateTime(DateTime dateTime) {
    return dateTime.toLocal();
  }
  static List<DateTime> getDaysInBetween(DateTime? startDate, DateTime? endDate) {
    List<DateTime> days = [];

    if(startDate == null || endDate == null) {
      return days;
    }

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }
  static List<int> getDaysOfMonth(int month, int year) {
    return List.generate(
        getLastDayOfMonth(month, year), (index) => index + 1,
        growable: false);
  }
  //string
  static String formatDateReadable(DateTime dateTime) {
    return DateFormat.yMMMMEEEEd().add_Hms().format(getMyDateTime(dateTime.toLocal()));
  }
  static String formatDateTimeOnly(DateTime dateTime) {
    return DateFormat("EEEE d, h:mm a").format(getMyDateTime(dateTime.toLocal()));
  }
  static String getMonthFromInt(int month) {
    assert(month >= 0 || month <= 11);
    return MyMonths.values[month].name;
  }

  //future
  static bool isEven(int n) {
    return n % 2 == 0;
  }
  static bool isLeapYear(int year) {
    // flag to take a non-leap year by default
    bool isLeapYear = false;

    // If year is divisible by 4
    if (year % 4 == 0) {
      // To identify whether it
      // is a century year or
      // not
      if (year % 100 == 0) {
        // Checking if year is divisible by 400
        // therefore century leap year
        if (year % 400 == 0) {
          isLeapYear = true;
        } else {
          isLeapYear = false;
        }
      }

      // Out of if loop that is Non century year
      // but divisible by 4, therefore leap year
      isLeapYear = true;
    }
    // We land here when corresponding if fails
    // If year is not divisible by 4
    else {
      isLeapYear = false;
    }

    return isLeapYear;
  }
  static Future<bool> copyToClipboard(BuildContext context, String s, bool mounted) async {
    try {
      await Clipboard.setData(ClipboardData(text: s));
      return true;
    } catch(e) {
      return false;
    }
  }

  //int
  static int getIntFromMonth(String month) {
    return MyMonths.values
        .map((m) => m.name.toUpperCase())
        .toList()
        .indexWhere((e) => e == month.toUpperCase());
  }
  static int getLastDayOfMonth(int month, int year) {
    if (month == 1) {
      return isLeapYear(year) ? 29 : 28;
    } else if (isEven(month)) {
      return 30;
    } else {
      return 31;
    }
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
}

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

class SettingsList {
  String title;
  String subTitle;
  Widget icon;
  final void Function() onPressed;

  SettingsList(this.title, this.subTitle, this.icon, this.onPressed);
}

enum MyMonths {
  january("January"),
  february("February"),
  march("March"),
  april("April"),
  may("May"),
  june("June"),
  july("July"),
  august("August"),
  september("September"),
  october("October"),
  november("November"),
  december("December");

  final String title;
  const MyMonths(this.title);

  static List<String> get allMonths => MyMonths.values.map((e) => e.title).toList(growable: false);
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