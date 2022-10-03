import '../rest_result.dart';
import '../client.dart';

/// Authorizes the email and password.  Returns member data and sign-in token and will be use all the session.
Future<RestResult> authenSignIn(
  Client client, {
  required String email,
  required String password,
  bool outputJsonLog = false,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('authen/signin'),
    body: client.formatJson({
      'signin': {
        'email': email,
        'password': password,
      },
    }, outputLog: outputJsonLog),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Signs off from current session.  The sign-in token will be invalid.
Future<RestResult> authenSignOut(
  Client client, {
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('authen/signout'),
    token: token,
    customHeaders: customHeaders,
  );
}

/// Checks current sign-in state.
Future<RestResult> authenCheck(
  Client client, {
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.get,
    client.url('authen/check'),
    token: token,
    customHeaders: customHeaders,
  );
}
