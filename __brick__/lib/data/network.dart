import 'dart:convert';

import '../utils/exceptions/exceptions.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart' as io;

Logger _log = Logger('network.dart');


enum RequestType {
  get,post,put,delete,head,patch;
}

enum HttpStatusCodes {
  /// Status Codes
  /// This interim response indicates that everything so far is OK
  /// and that the client should continue with the request or
  /// ignore it if it is already finished.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.2.1
  ///
  CONTINUE(100,"Continue"),

  /// This code is sent in response to an Upgrade request header by the client,
  /// and indicates the protocol the server is switching too.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.2.2
  ///
   SWITCHING_PROTOCOLS(101,"Switching Protocols"),

  /// This code indicates that the server has received and is processing
  /// the request, but no response is available yet.
  ///
  /// https://tools.ietf.org/html/rfc2518#section-10.1
  ///
   PROCESSING(102,"Switching Protocols"),

  CHECKPOINT(103,"Checkpoint"),

  /// The request has succeeded. The meaning of a success varies
  /// depending on the HTTP method:
  ///
  /// GET: The resource has been fetched and is transmitted in the message body.
  /// HEAD: The entity headers are in the message body.
  /// POST: The resource describing the result of the action is transmitted in the message body.
  /// TRACE: The message body contains the request message as received by the server
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.3.1
  ///
   OK(200,"OK"),

  /// The request has succeeded and a new resource has been created
  /// as a result of it. This is typically the response sent
  /// after a PUT request.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.3.2
  ///
   CREATED(201,"Created"),

  /// The request has been received but not yet acted upon.
  /// It is non-committal, meaning that there is no way in HTTP to later send
  /// an asynchronous response indicating the outcome of processing the request.
  /// It is intended for cases where another process or server handles
  /// the request, or for batch processing.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.3.3
  ///
   ACCEPTED(202,"Accepted"),

  /// This response code means returned meta-information set
  /// is not exact set as available from the origin server, but collected
  /// from a local or a third party copy.
  ///
  /// Except this condition, 200 OK response should be preferred
  /// instead of this response.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.3.4
  ///
   NON_AUTHORITATIVE_INFORMATION(203,"Non-Authoritative Information"),

  /// There is no content to send for this request, but the headers
  /// may be useful. The user-agent may update its cached headers
  /// for this resource with the new ones.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.3.5
  ///
   NO_CONTENT(204,"No Content"),

  /// This response code is sent after accomplishing request to tell
  /// user agent reset document view which sent this request.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.3.6
  ///
   RESET_CONTENT(205,"Reset Content"),

  /// This response code is used because of range header sent by the client
  /// to separate download into multiple streams.
  ///
  /// https://tools.ietf.org/html/rfc7233#section-4.1
  ///
   PARTIAL_CONTENT(206,"Partial Content"),

  /// A Multi-Status response conveys information about multiple resources
  /// in situations where multiple status codes might be appropriate.
  ///
  /// https://tools.ietf.org/html/rfc2518#section-10.2
  ///
   MULTI_STATUS(207,"Multi-Status"),

   ALREADY_REPORTED(208,"Already Reported"),
   IM_USED(226, "IM Used"),

  /// The request has more than one possible responses.
  /// User-agent or user should choose one of them.
  ///
  /// There is no standardized way to choose one of the responses.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.4.1
   MULTIPLE_CHOICES(300,"Multiple Choices"),

  /// This response code means that URI of requested resource has been changed.
  /// Probably, new URI would be given in the response.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.4.2
  ///
   MOVED_PERMANENTLY(301,"Moved Permanently"),

  /// This response code means that URI of requested resource has been
  /// changed temporarily. New changes in the URI might be made in the future.
  /// Therefore, this same URI should be used by the client in future requests.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.4.3
  ///
   MOVED_TEMPORARILY(302,"Moved Temporarily"),

  /// Server sent this response to directing client to get requested resource
  /// to another URI with an GET request.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.4.4
  ///
   SEE_OTHER(303, "See Other"),

  /// This is used for caching purposes. It is telling to client that
  /// response has not been modified. So, client can continue to use
  /// same cached version of response.
  ///
  /// https://tools.ietf.org/html/rfc7232#section-4.1
  ///
   NOT_MODIFIED(304, "Not Modified"),

  /// @deprecated
  /// Was defined in a previous version of the HTTP specification to indicate
  /// that a requested response must be accessed by a proxy.
  ///
  /// It has been deprecated due to security concerns regarding
  /// in-band configuration of a proxy.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.4.6
  ///
   USE_PROXY(305, "Use Proxy"),

  /// Server sent this response to directing client to get requested resource
  /// to another URI with same method that used prior request.
  ///
  /// This has the same semantic than the 302 Found HTTP response code,
  /// with the exception that the user agent must not change
  /// the HTTP method used:
  ///
  /// if a POST was used in the first request, a POST must be used
  /// in the second request.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.4.7
  ///
   TEMPORARY_REDIRECT(307, "Temporary Redirect"),

  /// This means that the resource is now permanently located at another URI,
  /// specified by the Location: HTTP Response header.
  ///
  /// This has the same semantics as the 301 Moved Permanently HTTP
  /// response code, with the exception that the user agent must not change
  /// the HTTP method used: if a POST was used in the first request,
  /// a POST must be used in the second request.
  ///
  /// https://tools.ietf.org/html/rfc7538#section-3
  ///
   PERMANENT_REDIRECT(308,"Permanent Redirect"),

  /// This response means that server could not understand
  /// the request due to invalid syntax.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.1
  ///
   BAD_REQUEST(400, "Bad Request"),

  /// Although the HTTP standard specifies "unauthorized", semantically
  /// this response means "unauthenticated". That is, the client must
  /// authenticate itself to get the requested response.
  ///
  /// https://tools.ietf.org/html/rfc7235#section-3.1
  ///
   UNAUTHORIZED(401, "Unauthorized"),

  /// This response code is reserved for future use. Initial aim for creating
  /// this code was using it for digital payment systems
  /// however this is not used currently.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.2
  ///
   PAYMENT_REQUIRED(402, "Payment Required"),

  /// The client does not have access rights to the content, i.e.
  /// they are unauthorized, so server is rejecting to give proper response.
  /// Unlike 401, the client's identity is known to the server.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.3
  ///
   FORBIDDEN(403, "Forbidden"),

  /// The server can not find requested resource.
  ///
  /// In the browser, this means the URL is not recognized.
  /// In an API, this can also mean that the endpoint is valid but
  /// the resource itself does not exist.
  ///
  /// Servers may also send this response instead of 403 to hide
  /// the existence of a resource from an unauthorized client.
  ///
  /// This response code is probably the most famous one due to
  /// its frequent occurence on the web.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.4
  ///
   NOT_FOUND(404, "Not Found"),

  /// The request method is known by the server but has been disabled
  /// and cannot be used. For example, an API may forbid DELETE-ing a resource.
  /// The two mandatory methods, GET and HEAD, must never be disabled and
  /// should not return this error code.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.5
  ///
   METHOD_NOT_ALLOWED(405, "Method Not Allowed"),

  /// This response is sent when the web server, after performing
  /// server-driven content negotiation, doesn't find any content
  /// following the criteria given by the user agent.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.6
  ///
   NOT_ACCEPTABLE(406, "Not Acceptable"),

  /// This is similar to 401 but authentication is needed to be done by a proxy.
  ///
  /// https://tools.ietf.org/html/rfc7235#section-3.2
  ///
   PROXY_AUTHENTICATION_REQUIRED(407, "Proxy Authentication Required"),

  /// This response is sent on an idle connection by some servers,
  /// even without any previous request by the client.
  ///
  /// It means that the server would like to shut down this unused connection.
  ///
  /// This response is used much more since some browsers, like Chrome,
  /// Firefox 27+, or IE9, use HTTP pre-connection mechanisms
  /// to speed up surfing.
  ///
  /// Also note that some servers merely shut down the connection
  /// without sending this message.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.7
  ///
   REQUEST_TIMEOUT(408,"Request Timeout"),

  /// This response is sent when a request conflicts with
  /// the current state of the server.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.8
  ///
   CONFLICT(409, "Conflict"),

  /// This response would be sent when the requested content has been
  /// permenantly deleted from server, with no forwarding address.
  ///
  /// Clients are expected to remove their caches and links to the resource.
  ///
  /// The HTTP specification intends this status code to be used for
  /// "limited-time, promotional services".
  ///
  /// APIs should not feel compelled to indicate resources that have been
  /// deleted with this status code.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.9
  ///
   GONE(410, "Gone"),

  /// The server rejected the request because the Content-Length header
  /// field is not defined and the server requires it.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.10
  ///
   LENGTH_REQUIRED(411, "Length Required"),

  /// The client has indicated preconditions in its headers
  /// which the server does not meet.
  ///
  /// https://tools.ietf.org/html/rfc7232#section-4.2
  ///
   PRECONDITION_FAILED(412, "Precondition Failed"),

  /// Request entity is larger than limits defined by server; the server
  /// might close the connection or return an Retry-After header field.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.11
  ///
  PAYLOAD_TOO_LARGE(413 ,"Payload Too Large"),

  /// The URI requested by the client is longer than the server is
  /// willing to interpret.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.12
  ///
  URI_TOO_LONG(414, "URI Too Long"),

  /// The media format of the requested data is not supported by the server,
  /// so the server is rejecting the request.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.13
  ///
   UNSUPPORTED_MEDIA_TYPE(415, "Unsupported Media Type"),

  /// The range specified by the Range header field in the request
  /// can't be fulfilled; it's possible that the range is outside
  /// the size of the target URI's data.
  ///
  /// https://tools.ietf.org/html/rfc7233#section-4.4
  ///
   REQUESTED_RANGE_NOT_SATISFIABLE(416, "Requested range not satisfiable"),

  /// This response code means the expectation indicated by the Expect
  /// request header field can't be met by the server.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.5.14
  ///
   EXPECTATION_FAILED(417, "Expectation Failed"),

  /// Any attempt to brew coffee with a teapot should result in
  /// the error code "418 I'm a teapot".
  ///
  /// The resulting entity body MAY be short and stout.
  ///
  /// https://tools.ietf.org/html/rfc2324#section-2.3.2
  ///
   IM_A_TEAPOT(418, "I'm a teapot"),

  /// The 507 (Insufficient Storage) status code means the method could not
  /// be performed on the resource because the server is unable to store
  /// the representation needed to successfully complete the request.
  ///
  /// This condition is considered to be temporary.
  ///
  /// If the request which received this status code was the result
  /// of a user action, the request MUST NOT be repeated until
  /// it is requested by a separate user action.
  ///
  /// https://tools.ietf.org/html/rfc2518#section-10.6
  ///
   INSUFFICIENT_SPACE_ON_RESOURCE(419, "Insufficient Space On Resource"),

  /// @deprecated
  /// A deprecated response used by the Spring Framework when a method has failed.
  ///
  /// https://tools.ietf.org/rfcdiff?difftype=--hwdiff&url2=draft-ietf-webdav-protocol-06.txt
  ///
   METHOD_FAILURE(420, "Method Failure"),

  /// The request was well-formed but was unable to be followed
  /// due to semantic errors.
  ///
  /// https://tools.ietf.org/html/rfc2518#section-10.3
  ///
   UNPROCESSABLE_ENTITY(422, "Unprocessable Entity"),

  /// The resource that is being accessed is locked.
  ///
  /// https://tools.ietf.org/html/rfc2518#section-10.4
  ///
   LOCKED(423,"Locked"),

  /// The request failed due to failure of a previous request.
  ///
  /// https://tools.ietf.org/html/rfc2518#section-10.5
  ///
   FAILED_DEPENDENCY(424, "Failed Dependency"),

  /// The origin server requires the request to be conditional.
  ///
  /// Intended to prevent the 'lost update' problem, where a client GETs
  /// a resource's state, modifies it, and PUTs it back to the server,
  /// when meanwhile a third party has modified the state
  /// on the server, leading to a conflict.
  ///
  /// https://tools.ietf.org/html/rfc6585#section-3
  ///
  TOO_EARLY(425, "Too Early"),
  UPGRADE_REQUIRED(426, "Upgrade Required"),

  PRECONDITION_REQUIRED(428, "Precondition Required"),

  /// The user has sent too many requests
  /// in a given amount of time ("rate limiting").
  ///
  /// https://tools.ietf.org/html/rfc6585#section-4
  ///
   TOO_MANY_REQUESTS(429,"Too Many Requests"),

  /// The server is unwilling to process the request because its header fields
  /// are too large. The request MAY be resubmitted after reducing
  /// the size of the request header fields.
  ///
  /// https://tools.ietf.org/html/rfc6585#section-5
  ///
   REQUEST_HEADER_FIELDS_TOO_LARGE(431,"Request Header Fields Too Large"),

  /// The user-agent requested a resource that cannot legally be provided,
  /// such as a web page censored by a government.
  ///
  /// https://tools.ietf.org/html/rfc7725
  ///
   UNAVAILABLE_FOR_LEGAL_REASONS(451,"Unavailable For Legal Reasons"),

  /// The server encountered an unexpected condition that prevented it
  /// from fulfilling the request.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.6.1
  ///
   INTERNAL_SERVER_ERROR(500, "Internal Server Error"),

  /// The request method is not supported by the server and cannot be handled.
  ///
  /// The only methods that servers are required to support (and therefore
  /// that must not return this code) are GET and HEAD.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.6.2
  ///
   NOT_IMPLEMENTED(501, "Not Implemented"),

  /// This error response means that the server, while working as a gateway
  /// to get a response needed to handle the request, got an invalid response.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.6.3
  ///
   BAD_GATEWAY(502, "Bad Gateway"),

  /// The server is not ready to handle the request.
  ///
  /// Common causes are a server that is down for maintenance or that is
  /// overloaded. Note that together with this response, a user-friendly page
  /// explaining the problem should be sent.
  ///
  /// This responses should be used for temporary conditions
  /// and the Retry-After: HTTP header should, if possible, contain
  /// the estimated time before the recovery of the service.
  ///
  /// The webmaster must also take care about the caching-related headers
  /// that are sent along with this response, as these temporary condition
  /// responses should usually not be cached.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.6.4
  ///
   SERVICE_UNAVAILABLE(503, "Service Unavailable"),

  /// This error response is given when the server is acting as a gateway
  /// and cannot get a response in time.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.6.5
  ///
   GATEWAY_TIMEOUT(504, "Gateway Timeout"),

  /// The HTTP version used in the request is not supported by the server.
  ///
  /// https://tools.ietf.org/html/rfc7231#section-6.6.6
  ///
   HTTP_VERSION_NOT_SUPPORTED(505, "HTTP Version not supported"),

  /// The server has an internal configuration error: the chosen variant
  /// resource is configured to engage in transparent content negotiation
  /// itself, and is therefore not a proper end point
  /// in the negotiation process.
  ///
  /// https://tools.ietf.org/html/rfc2518#section-10.6
  ///
  ///
  VARIANT_ALSO_NEGOTIATES(506, "Variant Also Negotiates"),
  INSUFFICIENT_STORAGE(507,"Insufficient Storage"),

  LOOP_DETECTED(508,"Loop Detected"),

  BANDWIDTH_LIMIT_EXCEEDED(509,"Bandwidth Limit Exceeded"),


  NOT_EXTENDED(510, "Not Extended"),

  /// The 511 status code indicates that the client needs to authenticate
  /// to gain network access.
  ///
  /// https://tools.ietf.org/html/rfc6585#section-6
  ///
  NETWORK_AUTHENTICATION_REQUIRED (511, "Network Authentication Required");

  final int status;
  final String phrase;
  const HttpStatusCodes(this.status,this.phrase);

  static HttpStatusCodes? findByCode (int statusCode) {
    return values.where((e) => e.status == statusCode).first;
  }

}

class NetworkResponse {
  Response? response;
  Failure? failure;

  NetworkResponse({this.response, this.failure}) {
   if(!hasFailure() && !hasResponse()) {
     throw IllegalStateFailure("Response and Failure cannot both be null");
   }

  }
  
  bool hasFailure () {
    return failure != null;
  }
  
  bool hasResponse () {
    return response != null;
  }
  
}

abstract class NetworkRepository {
  Future<NetworkResponse> sendRequest(Uri url,RequestType requestType,{Map<String,String>? headers, Object? body, List<HttpStatusCodes>? successCodes, Encoding? encoding});
  Future<bool> hasConnection();
  bool isSuccessfulResponse(Response response,List<HttpStatusCodes>? successCodes);
}

class NetworkRepositoryImpl extends NetworkRepository {

  late String testLookUpAddress;
  late int successTestLookUpStatus;
  List<HttpStatusCodes>? universalSuccessCodes;

  NetworkRepositoryImpl({String? lookUpAddress, int? successLookUpStatus,List<HttpStatusCodes>? universalSuccessCodes}) {
    this.testLookUpAddress = lookUpAddress ?? "https://httpbin.org/ip";
    this.successTestLookUpStatus = successLookUpStatus ?? 200;
    this.universalSuccessCodes = universalSuccessCodes;
  }

  @override
  Future<NetworkResponse> sendRequest(Uri uri, RequestType requestType, {Map<String,String>? headers, Object? body,List<HttpStatusCodes>? successCodes,Encoding? encoding}) async {
    if(!(await hasConnection())) {
      _log.info("Internet connection test failed");
      return NetworkResponse(failure: ConnectionFailure(null));
    }

    String? jsonBody;

    if(body != null) {
      jsonBody = jsonEncode(body);
    }
    
    switch(requestType) {

      case RequestType.get:
        try {
        Response res = await get(uri,headers: headers);
         if(isSuccessfulResponse(res,successCodes)) {
           return NetworkResponse(response: res);
         } else {
           HttpStatusCodes? httpStatusCodes = HttpStatusCodes.findByCode(res.statusCode);
           return NetworkResponse(failure: ServerFailure.fromHttpStatusCode(httpStatusCodes, res));
         }
        } on io.SocketException catch(e) {
          return NetworkResponse(failure: ConnectionFailure(e.message, sent: true));
        }
      case RequestType.post:
        try {
          Response res = await post(uri,headers: headers,body:jsonBody,encoding: encoding);
          if(isSuccessfulResponse(res,successCodes)) {
            return NetworkResponse(response: res);
          } else {
            HttpStatusCodes? httpStatusCodes = HttpStatusCodes.findByCode(res.statusCode);
            return NetworkResponse(failure: ServerFailure.fromHttpStatusCode(httpStatusCodes, res));
          }
        } on io.SocketException catch(e) {
          return NetworkResponse(failure: ConnectionFailure(e.message, sent: true));
        }
      case RequestType.put:
        try {
          Response res = await put(uri,headers: headers,body: jsonBody,encoding: encoding);
          if(isSuccessfulResponse(res,successCodes)) {
            return NetworkResponse(response: res);
          } else {
            HttpStatusCodes? httpStatusCodes = HttpStatusCodes.findByCode(res.statusCode);
            return NetworkResponse(failure: ServerFailure.fromHttpStatusCode(httpStatusCodes, res));
          }
        } on io.SocketException catch(e) {
          return NetworkResponse(failure: ConnectionFailure(e.message, sent: true));
        }
      case RequestType.delete:
        try {
          Response res = await delete(uri,headers: headers,body:jsonBody,encoding: encoding);
          if(isSuccessfulResponse(res,successCodes)) {
            return NetworkResponse(response: res);
          } else {
            HttpStatusCodes? httpStatusCodes = HttpStatusCodes.findByCode(res.statusCode);
            return NetworkResponse(failure: ServerFailure.fromHttpStatusCode(httpStatusCodes, res));
          }
        } on io.SocketException catch(e) {
          return NetworkResponse(failure: ConnectionFailure(e.message, sent: true));
        }
      case RequestType.head:
        try {
          Response res = await delete(uri,headers: headers,body: jsonBody,encoding: encoding);
          if(isSuccessfulResponse(res,successCodes)) {
            return NetworkResponse(response: res);
          } else {
            HttpStatusCodes? httpStatusCodes = HttpStatusCodes.findByCode(res.statusCode);
            return NetworkResponse(failure: ServerFailure.fromHttpStatusCode(httpStatusCodes, res));
          }
        } on io.SocketException catch(e) {
          return NetworkResponse(failure: ConnectionFailure(e.message, sent: true));
        }
      case RequestType.patch:
        try {
          Response res = await patch(uri,headers: headers,body: jsonBody, encoding: encoding);
          if(isSuccessfulResponse(res,successCodes)) {
            return NetworkResponse(response: res);
          } else {
            HttpStatusCodes? httpStatusCodes = HttpStatusCodes.findByCode(res.statusCode);
            return NetworkResponse(failure: ServerFailure.fromHttpStatusCode(httpStatusCodes, res));
          }
        } on io.SocketException catch(e) {
          return NetworkResponse(failure: ConnectionFailure(e.message, sent: true));
        }
    }
  }

  @override
  Future<bool> hasConnection () async {
    //todo change implementation for your app
    /*try {
      final result = await io.InternetAddress.lookup(lookUpAddress);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on io.SocketException catch (_) {
      return false;
    } catch (e,trace) {
      //web throws unimplemented exception
      return false;
    }*/
    try {
      Response? test = await get(Uri.parse(testLookUpAddress));
      return test.statusCode == successTestLookUpStatus;
    } catch(e) {
      return false;
    }
  }

  @override
  bool isSuccessfulResponse(Response response, List<HttpStatusCodes>? successCodes) {
    if(successCodes != null) {
      return successCodes.map((e) => e.status).contains(response.statusCode);
    }

    if (universalSuccessCodes != null) {
      return universalSuccessCodes!.map((e) => e.status).contains(response.statusCode);
    }

    //default
    //todo change for your app
    return (response.statusCode >= 200 && response.statusCode < 300);
  }

}

