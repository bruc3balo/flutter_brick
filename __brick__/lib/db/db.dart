import 'package:bruce_brick/utils/mplatform.dart';
import 'package:bruce_brick/utils/reusables.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

var storage = Hive.box(MyVariables.appName);

Future<void> openHiveBox() async {

  if(!Mplatform.isWeb()) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }

  await Hive.openBox(MyVariables.appName);
}

Future<void> clearAllData() async{
  await storage.clear();
}
