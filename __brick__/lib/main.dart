import 'package:flutter_brick/data/db.dart';
import 'package:flutter_brick/data/network.dart';
import 'package:flutter_brick/utils/reusables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'utils/routes.dart';
import 'utils/styles/styles.dart';
import 'utils/url/url_strategy.dart';

Logger _log = Logger('main.dart');
final getIt = GetIt.instance;

Future<void> _beforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();


  //logs
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) => _handleLogs(record));
  _log.info("Starting application ${MyVariables.appName}");

  //widgets
  usePathUrlStrategy();

  //local data
  getIt.registerLazySingleton<HiveInterface>(() => Hive);
  getIt.registerLazySingleton<LocalDatabase>(() => LocalDataBaseImpl());
  getIt<LocalDatabase>();

  //network
  getIt.registerLazySingleton<NetworkRepository>(() => NetworkRepositoryImpl());
}

void _handleLogs(LogRecord record) {
  debugPrint('${record.level.name}: ${record.time}: ''${record.loggerName}: ''${record.message}');
}

void main() {
  _beforeRunApp()
      .then((value) => runApp(const MyApp()))
      .catchError((onError) {
    debugPrint(onError.toString());
    print("Application failed to start");
    MyMethods.killApp();
  });
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (___,constraints) {
          screenSizeProvider.updateSize(width: constraints.maxWidth, height: constraints.maxHeight);
          return ValueListenableBuilder(
              valueListenable: themeProvider,
              builder: (__,MyThemeModes themeMode, _) {
                debugPrint("${themeMode.name}");
                return MaterialApp(
                  key: key,
                  title: MyVariables.appName,
                  initialRoute: MyVariables.splashScreenRoute,
                  onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => const UnKnownPage()),
                  onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
                  scrollBehavior: MyWidgets.getNoScrollBehaviour(context),
                  useInheritedMediaQuery: true,
                  theme: themeProvider.current.data,
                );
              }
          );
        }
    );
  }

}



