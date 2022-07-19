//exceptions

import '/data/network.dart' hide Logger;
import 'package:http/http.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('exceptions.dart');


class ConnectionException implements Exception {

}

class DatabaseException implements Exception {}

class ServerException implements Exception {}

class IllegalStateException implements Exception {}

//failures
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ConnectionFailure extends Failure {
  late bool sent;
  ConnectionFailure(String? message,{bool? sent}) : super (message ?? "Internet connection unavailable") {
    sent = sent ?? false;
    if(!sent) {
      _log.info(message);
    }
  }
}

class DatabaseFailure extends Failure {
   DatabaseFailure(String message) : super(message) {
    _log.warning(message);
  }
}

class ServerFailure extends Failure {
  int status;
  ServerFailure({required String message,required this.status}) : super(message) {
    _log.warning(message);
  }

  static ServerFailure fromHttpStatusCode(HttpStatusCodes? httpStatusCodes,Response response) {
    return ServerFailure(message:httpStatusCodes?.phrase ?? "Failed", status: httpStatusCodes?.status ?? response.statusCode);
  }
}

class IllegalStateFailure extends Failure {
   IllegalStateFailure(String message) : super(message) {
    _log.warning(message);
  }
}

