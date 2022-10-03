import '../rest_result.dart';
import '../client.dart';

/// Authorizes the member signing-up.  This service is primary used in testing only.
Future<RestResult> adminMembersAuthorize(
  Client client, {
  required String code,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  Map<String, String> query = {
    'code': code,
  };
  return await client.call(
    MethodType.put,
    client.url('admin/members/authorize', query),
    token: token,
    customHeaders: customHeaders,
  );
}
// ----------------------------------------------------------------------

/// Disables or enables a member.
Future<RestResult> adminMembersDisable(
  Client client, {
  required String email,
  required bool disabled,
  bool outputJsonLog = false,
  String? token,
  Map<String, String>? customHeaders,
}) async {
  return await client.call(
    MethodType.put,
    client.url('admin/members/disable/$email'),
    body: client.formatJson({
      'member': {
        'disabled': disabled,
      },
    }, outputLog: outputJsonLog),
    token: token,
    customHeaders: customHeaders,
  );
}
