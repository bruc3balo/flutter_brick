//exceptions
import 'package:bruce_brick/data/network.dart';
import 'package:http/http.dart';

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
  bool? sent;
  ConnectionFailure(String? message,{this.sent}) : super (message ?? "Internet connection unavailable") {
    sent = sent ?? false;
  }
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  int status;
  ServerFailure({required String message,required this.status}) : super(message);

  static ServerFailure fromHttpStatusCode(HttpStatusCodes? httpStatusCodes,Response response) {
    return ServerFailure(message:httpStatusCodes?.phrase ?? "Failed", status: httpStatusCodes?.status ?? response.statusCode);
  }
}

class IllegalStateFailure extends Failure {
  const IllegalStateFailure(String message) : super(message);
}

