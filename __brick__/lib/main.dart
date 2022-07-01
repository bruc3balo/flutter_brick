import 'package:bruce_brick/utils/resusables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'utils/resusables.dart';
import 'utils/routes.dart';
import 'utils/url/url_strategy.dart';

Logger _log = Logger('main.dart');

void main() {
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) => _handleLogs(record));
  WidgetsFlutterBinding.ensureInitialized();
  _log.info("Starting application");
  usePathUrlStrategy();
  runApp(const MyApp());
}

void _handleLogs(LogRecord record) {
  debugPrint('${record.level.name}: ${record.time}: ''${record.loggerName}: ''${record.message}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MyThemes.currentTheme,
      builder: (__,MyThemeModes themeMode, _) {
        return MaterialApp(
          key: key,
          title: MyVariables.appName,
          initialRoute: MyVariables.splashScreenRoute,
          onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => const UnKnownPage()),
          onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
          scrollBehavior: MyWidgets.getNoScrollBehaviour(context),
          useInheritedMediaQuery: true,
          theme: themeMode.data,
        );
      }
    );
  }
}

