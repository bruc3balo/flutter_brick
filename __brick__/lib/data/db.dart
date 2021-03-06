import '../utils/exceptions/exceptions.dart';
import '../utils/mplatform.dart';
import '../utils/reusables.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

Logger _log = Logger('db.dart');


abstract class LocalDatabase {
  Future<void> clearAllData();
  //todo put CRUD methods here
}

class LocalDataBaseImpl extends LocalDatabase {

  LocalDataBaseImpl({String? name}) {
    init().then((value) => _getHiveBox(name: name)).catchError((onError,trace) => throw DatabaseFailure(onError.toString()));
  }

  @override
  Future<void> clearAllData() async {
    try {
      //todo add all boxes here
      Box? box = await _getHiveBox();
      box?.clear();
      _log.info("Database cleared");
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  //@override
  Future<Box?> _getHiveBox({String? name}) async {
    try {
      return await Hive.openBox(name ?? MyVariables.appName);
    } catch(e) {
      throw DatabaseFailure(e.toString());
    }
  }

  Future<void> init () async {
    if(!Mplatform.isWeb()) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  }

}