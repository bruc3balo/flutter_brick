import 'package:bruce_brick/utils/resusables.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


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



