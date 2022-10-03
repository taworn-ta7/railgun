import '../rest_result.dart';
import '../client.dart';

/// Receives sign-up form and saves it to database.  Returns URL to let user confirm it.
Future<RestResult> membersSignUp(
  Client client, {
  required String email,
  required String password,
  required String confirmPassword,
  required String locale,
  bool outputJsonLog = false,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.post,
    client.url('members/signup'),
    body: client.formatJson({
      'member': {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'locale': locale,
      },
    }, outputLog: outputJsonLog),
    token: token,
    customHeaders: customHeaders,
  );
}

// ----------------------------------------------------------------------

/// Receives password reset form and sends email to member.
Future<RestResult> membersPasswordReset(
  Client client, {
  required String email,
  bool outputJsonLog = false,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.post,
    client.url('members/request-reset'),
    body: client.formatJson({
      'member': {
        'email': email,
      },
    }, outputLog: outputJsonLog),
    token: token,
    customHeaders: customHeaders,
  );
}

// ----------------------------------------------------------------------

/// Lists members with conditions.  All parameters are optional.
Future<RestResult> membersList(
  Client client, {
  Map<String, String>? queryPage,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.get,
    client.url('members', queryPage),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Gets member's information.
Future<RestResult> membersGet(
  Client client, {
  required String email,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.get,
    client.url('members/$email'),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Gets member's icons.
Future<RestResult> membersGetIcon(
  Client client, {
  required String email,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.get,
    client.url('members/$email/icon'),
    token: token,
    customHeaders: customHeaders,
  );
}
