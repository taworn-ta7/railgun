import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import './rest_result.dart';

/// HTTP methods.
enum MethodType {
  delete,
  get,
  head,
  patch,
  post,
  put,
}

/// Client connection manager.
class Client {
  static final log = Logger('Client');

  /// Base URL.
  String _baseUrl = '';
  String get baseUrl => _baseUrl;

  /// Constructor.
  Client({required String baseUrl}) {
    if (!baseUrl.endsWith('/')) baseUrl += '/';
    _baseUrl = baseUrl;
  }

  /// Default constructor.
  factory Client.def() => Client(baseUrl: 'http://127.0.0.1:7777/api/');

  // ----------------------------------------------------------------------

  /// JSON formatter.
  static const _formatter = JsonEncoder.withIndent('  ');

  /// Formats JSON map to string.
  String formatJson(
    Object data, {
    bool outputLog = false,
  }) {
    final json = _formatter.convert(data);
    if (outputLog) log.finer("JSON: $json");
    return json;
  }

  /// Concats base URL with address, optional with trailed query string.
  Uri url(String address, [Map<String, String>? query]) {
    var params = Uri(queryParameters: query).query;
    if (params != '') params = '?$params';
    final url = Uri.parse('$baseUrl$address$params');
    return url;
  }

  // ----------------------------------------------------------------------

  /// Authen token.
  String? token;

  // ----------------------------------------------------------------------

  /// Gets default headers.
  Map<String, String> defaultHeaders([String? token]) {
    String? t = token ?? this.token;
    return {
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'Bearer $t',
    };
  }

  /// Gets multi-part headers.
  Map<String, String> formDataHeaders([String? token]) {
    String? t = token ?? this.token;
    return {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $t',
    };
  }

  // ----------------------------------------------------------------------

  /// Calls HTTP.  Returns RestResult.
  Future<RestResult> call(
    MethodType method,
    Uri url, {
    Object? body,
    String? token,
    Map<String, String>? customHeaders,
  }) async {
    try {
      Map<String, String>? headers = customHeaders ?? defaultHeaders(token);

      late http.Response res;
      switch (method) {
        case MethodType.delete:
          log.info("DELETE $url...");
          res = await http.delete(url, headers: headers, body: body);
          break;
        case MethodType.get:
          log.info("GET $url...");
          res = await http.get(url, headers: headers);
          break;
        case MethodType.head:
          log.info("HEAD $url...");
          res = await http.head(url, headers: headers);
          break;
        case MethodType.patch:
          log.info("PATCH $url...");
          res = await http.patch(url, headers: headers, body: body);
          break;
        case MethodType.post:
          log.info("POST $url...");
          res = await http.post(url, headers: headers, body: body);
          break;
        case MethodType.put:
          log.info("PUT $url...");
          res = await http.put(url, headers: headers, body: body);
          break;
      }

      return RestResult(res);
    } catch (ex) {
      return RestResult.error(ex.toString());
    }
  }

  /// Uploads file via HTTP.  Returns RestResult.
  Future<RestResult> upload(
    MethodType method,
    Uri url, {
    required http.MultipartFile file,
    String? token,
    Map<String, String>? customHeaders,
  }) async {
    try {
      late http.MultipartRequest req;
      switch (method) {
        case MethodType.put:
          log.info("PUT $url...");
          req = http.MultipartRequest('PUT', url);
          break;
        case MethodType.post:
        default:
          log.info("POST $url...");
          req = http.MultipartRequest('POST', url);
          break;
      }

      Map<String, String>? headers = customHeaders ?? formDataHeaders(token);
      req.headers.addAll(headers);
      req.files.add(file);

      final res = await req.send();
      return RestResult(await http.Response.fromStream(res));
    } catch (ex) {
      return RestResult.error(ex.toString());
    }
  }
}
