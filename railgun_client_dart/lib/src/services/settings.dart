import '../rest_result.dart';
import '../client.dart';

/// Changes current settings.  Currently, it has just one setting: locale.
Future<RestResult> settingsChange(
  Client client, {
  String? locale,
  bool outputJsonLog = false,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('settings/change'),
    body: client.formatJson({
      'member': {
        'locale': locale,
      },
    }, outputLog: outputJsonLog),
    token: token,
    customHeaders: customHeaders,
  );
}

// ----------------------------------------------------------------------

/// Sets key-value generic settings.
Future<RestResult> settingsSet(
  Client client, {
  required String key,
  required String value,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('settings/$key/$value'),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Gets key-value generic settings.  Returns value string, or null if key not exists.
Future<RestResult> settingsGet(
  Client client, {
  required String key,
  required String value,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.get,
    client.url('settings/$key'),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Gets all generic settings.  Returns all key-value pairs.
Future<RestResult> settingsGetAll(
  Client client, {
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.get,
    client.url('settings'),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Deletes all generic settings.  This function is use for reset.
Future<RestResult> settingsReset(
  Client client, {
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('settings'),
    token: token,
    customHeaders: customHeaders,
  );
}
