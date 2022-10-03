import 'package:logging/logging.dart';
import '../rest_result.dart';
import '../models/member_reset.dart';

/// Converts to member reset.
MemberReset toMemberReset(
  RestResult rest, [
  Logger? log,
]) {
  final item = MemberReset.fromJson(rest.json!['member']);
  if (log != null) log.finer("member: $item");
  return item;
}
