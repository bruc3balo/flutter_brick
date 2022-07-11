import 'package:bruce_brick/utils/reusables.dart';
import 'package:bruce_brick/utils/styles/styles.dart';
import 'package:flutter/material.dart';

import '../utils/routes.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    themeProvider.addListener(printTheme);
    Future.delayed(MyVariables.transitionDuration).then((value) => Routes.goToRouteNameBackBone(context, MyVariables.mainScreen));
    super.initState();
  }

  @override
  void dispose() {
    themeProvider.removeListener(printTheme);
    super.dispose();
  }

  void printTheme() {
    debugPrint("Listening to theme changes");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Image.asset("assets/icon.png",),
      ),
    );
  }

}



