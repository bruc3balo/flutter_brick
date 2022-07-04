import 'package:flutter/material.dart';
import '../utils/styles/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    MyThemes.currentTheme.addListener(() {
      debugPrint("Value is ${MyThemes.currentTheme.value}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              setState(() {
                if(MyThemes.currentTheme.value == MyThemeModes.light) {
                    MyThemes.currentTheme.value = MyThemeModes.dark;
                } else {
                  MyThemes.currentTheme.value = MyThemeModes.light;
                }
              });
              }, icon: Icon(MyThemes.currentTheme.value.name == MyThemeModes.light.name ? Icons.light_mode :Icons.dark_mode))
          ],
        ),
      ),
    );
  }
}



