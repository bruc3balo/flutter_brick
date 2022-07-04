import 'package:bruce_brick/utils/reusables.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../pages/splashscreen.dart';

class Routes {

  String name;
  String path;
  IconData icon;
  Function routeBuilder;

  Routes({required this.name, required this.path, required this.icon,required this.routeBuilder});

  static List<Routes> allRoutes = [
    Routes(
        routeBuilder: () => PageTransition(
            settings: const RouteSettings(name: MyVariables.splashScreenRoute),
            type: PageTransitionType.size,
            alignment: Alignment.center,
            curve: Curves.linearToEaseOut,
            opaque: true,
            child: const SplashScreen(),
            duration: MyVariables.transitionDuration
        ),
        path: MyVariables.splashScreenRoute,
        name: MyVariables.splashScreen,
        icon: Icons.open_in_new),
  ];

  static Routes getRouteByName(String name) {
    return allRoutes.firstWhere((route) => route.name == name);
  }

  static void goToRouteNameBackBone(BuildContext context, String routeName) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.getRouteByName(routeName).path, (Route<dynamic> route) => false);
  }

  static void goToRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(Routes.getRouteByName(routeName).path);
  }

  static void goToRouteArguments(BuildContext context, String routeName,Object data) {
    Navigator.of(context).pushNamed(Routes.getRouteByName(routeName).path, arguments: data);
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    for (var v in Routes.allRoutes) {
      if(settings.name == v.path) {
        return v.routeBuilder();
      }
    }
    return null;
  }
}


class UnKnownPage extends StatelessWidget {
  const UnKnownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}