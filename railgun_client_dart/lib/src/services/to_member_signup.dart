import 'package:logging/logging.dart';
import '../rest_result.dart';
import '../models/member_signup.dart';

/// Converts to member sign-up.
MemberSignUp toMemberSignUp(
  RestResult rest, [
  Logger? log,
]) {
  final item = MemberSignUp.fromJson(rest.json!['member']);
  if (log != null) log.finer("member: $item");
  return item;
}
