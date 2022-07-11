import 'package:bruce_brick/utils/mplatform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
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
  static const String mainScreenRoute = "/main";
  static const String mainScreen = "Main";
  static const Duration transitionDuration = Duration(milliseconds: 1500);
  static const double mobileWidth = 900; //715
}

class MyMethods {

  //void
  static void killApp() {
    debugPrint("Closing application");
    if (Mplatform.isWeb()) {
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

  //bool
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
    } else if (month.isEven) {
      return 30;
    } else {
      return 31;
    }
  }

}

class MySettingsList {
  String title;
  String subTitle;
  Widget icon;
  final void Function() onPressed;

  MySettingsList(this.title, this.subTitle, this.icon, this.onPressed);
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



