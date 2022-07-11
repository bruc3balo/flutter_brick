import 'package:flutter/material.dart';

import '../utils/styles/styles.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState () {
    themeProvider.addListener(() {
      debugPrint("Value is ${themeProvider.value}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        actions: [
          ValueListenableBuilder(
              valueListenable: themeProvider,
              builder: (__,MyThemeModes provider,child) {
                return IconButton(
                    onPressed: () {
                      if(themeProvider.isLightMode) {
                        themeProvider.changeTheme(themeMode: MyThemeModes.dark);
                      } else {
                        themeProvider.changeTheme(themeMode: MyThemeModes.light);
                      }
                    },
                    icon: Icon(themeProvider.isLightMode ? Icons.light_mode : Icons.dark_mode));
              }),
        ],
      ),
    ),);
  }
}
