import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import './rest_error.dart';

/// REST calls result.  It will returns in 4 cases:
/// - ok, statusCode = 200 or 201
/// - error, with other statusCode
/// - network error, not even get statusCode
/// - exception, just in case, handle same previous case.
class RestResult {
  static final log = Logger('RestResult');

  late final http.Response? res;
  late final bool ok;
  late final Map<String, dynamic>? json;
  late final RestError? error;
  late final String? errorMessage;

  RestResult(http.Response response) {
    res = response;

    ok = [200, 201].contains(res!.statusCode);

    try {
      json = jsonDecode(res!.body);
    } catch (ex) {
      json = null;
    }

    final req = res!.request!;
    final prefix = "${req.method} ${req.url}";
    if (ok) {
      // ok case
      error = null;
      errorMessage = null;
      log.info("$prefix: ${res!.statusCode} ${res!.reasonPhrase}");
    } else {
      if (json != null) {
        // error with statusCode
        error = RestError.fromJson(json!);
        errorMessage = null;
        log.warning("$prefix: ${res!.statusCode} ${res!.reasonPhrase}");
      } else {
        // network or server error
        error = null;
        errorMessage = "unknown error!";
        log.severe("$prefix: $errorMessage");
      }
    }
  }

  RestResult.error(String ex) {
    res = null;
    ok = false;
    json = null;
    error = null;
    errorMessage = ex;
    log.severe(errorMessage);
  }

  @override
  String toString() {
    final req = res!.request!;
    final prefix = "${req.method} ${req.url}";
    if (ok) {
      return "$prefix: ${res!.statusCode} ${res!.reasonPhrase}";
    } else {
      if (json != null) {
        return "$prefix: ${res!.statusCode} ${res!.reasonPhrase}";
      } else {
        return "$prefix: $errorMessage";
      }
    }
  }
}
