import 'dart:typed_data';
import './member.dart';

/// Member with profile icon.
class MemberIcon {
  Member member;
  Uint8List? icon;

  MemberIcon(
    this.member,
    this.icon,
  );
}
