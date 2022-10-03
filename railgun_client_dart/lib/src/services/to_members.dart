import 'package:logging/logging.dart';
import '../rest_result.dart';
import '../models/member.dart';
import '../models/member_icon.dart';

/// Converts to member.
Member toMember(
  RestResult rest, [
  Logger? log,
]) {
  final item = Member.fromJson(rest.json!['member']);
  if (log != null) log.finer("member: $item");
  return item;
}

/// Converts to member's token.
String toMemberToken(
  RestResult rest, [
  Logger? log,
]) {
  final item = rest.json!['token'];
  if (log != null) log.finer("token: $item");
  return item;
}

/// Converts to member list.
List<Member> toMemberList(
  RestResult rest, [
  Logger? log,
]) {
  final items = <Member>[];
  final list = rest.json!['members'];
  if (log != null) log.finer("find all, count: ${list.length}");
  for (var i = 0; i < list.length; i++) {
    final item = Member.fromJson(list[i]);
    if (log != null) log.finer("- $i: $item");
    items.add(item);
  }
  return items;
}

/// Converts to member iterator.
Iterable<Member> toMemberIterable(
  RestResult rest, [
  Logger? log,
]) sync* {
  final list = rest.json!['members'];
  if (log != null) log.finer("find all, count: ${list.length}");
  for (var i = 0; i < list.length; i++) {
    final item = Member.fromJson(list[i]);
    if (log != null) log.finer("- $i: $item");
    yield item;
  }
}

/// Converts to member with icon list.
List<MemberIcon> toMemberIconList(
  RestResult rest, [
  Logger? log,
]) {
  final items = <MemberIcon>[];
  final list = rest.json!['members'];
  if (log != null) log.finer("find all, count: ${list.length}");
  for (var i = 0; i < list.length; i++) {
    final item = Member.fromJson(list[i]);
    if (log != null) log.finer("- $i: $item");
    items.add(MemberIcon(item, null));
  }
  return items;
}

/// Converts to member with icon iterator.
Iterable<MemberIcon> toMemberIconIterable(
  RestResult rest, [
  Logger? log,
]) sync* {
  final list = rest.json!['members'];
  if (log != null) log.finer("find all, count: ${list.length}");
  for (var i = 0; i < list.length; i++) {
    final item = Member.fromJson(list[i]);
    if (log != null) log.finer("- $i: $item");
    yield MemberIcon(item, null);
  }
}
