import 'package:http/http.dart' as http;
import '../rest_result.dart';
import '../client.dart';

/// Uploads picture to use as member profile icon.
Future<RestResult> profileUploadIcon(
  Client client, {
  required http.MultipartFile file,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.upload(
    MethodType.post,
    client.url('profile/icon'),
    file: file,
    token: token,
    customHeaders: customHeaders,
  );
}

/// Views the uploaded profile icon.
Future<RestResult> profileViewIcon(
  Client client, {
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.get,
    client.url('profile/icon'),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Deletes the uploaded profile icon and reverts profile icon to defaults.
Future<RestResult> profileDeleteIcon(
  Client client, {
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.delete,
    client.url('profile/icon'),
    token: token,
    customHeaders: customHeaders,
  );
}

// ----------------------------------------------------------------------

/// Changes the current name.
Future<RestResult> profileChangeName(
  Client client, {
  required String name,
  bool outputJsonLog = false,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('profile/name'),
    body: client.formatJson({
      'member': {
        'name': name,
      },
    }, outputLog: outputJsonLog),
    token: token,
    customHeaders: customHeaders,
  );
}

// ----------------------------------------------------------------------

/// Changes the current password.  After the password is changed, you will be sign-out and need to sign-in again.
Future<RestResult> profileChangePassword(
  Client client, {
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
  bool outputJsonLog = false,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('profile/password'),
    body: client.formatJson({
      'member': {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    }, outputLog: outputJsonLog),
    token: token,
    customHeaders: customHeaders,
  );
}
