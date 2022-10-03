import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

/// Member entity.
@JsonSerializable()
class Member {
  static const emailMax = 254;
  static const roleList = ['member', 'admin'];
  static const localeList = ['en', 'th'];
  static const nameMin = 1;
  static const nameMax = 200;
  static const passwordMin = 4;
  static const passwordMax = 20;

  // ----------------------------------------------------------------------

  /// Id.
  String id;

  /// Email.
  String email;

  /// Role level, can be 'member' or 'admin'.
  String role;

  /// Locale, can be 'en' or 'th'.
  String locale;

  /// Display name.
  String name;

  // ----------------------------------------------------------------------

  /// Disabled by admin.
  DateTime? disabled;

  /// Resigned by this member.
  DateTime? resigned;

  // ----------------------------------------------------------------------

  /// Last sign-in date/time.
  DateTime? begin;

  /// Last sign-out date/time.
  DateTime? end;

  /// Session expiry date/time.
  DateTime? expire;

  // ----------------------------------------------------------------------

  /// Created date/time.
  DateTime? created;

  /// Updated date/time.
  DateTime? updated;

  /// Constructor.
  Member({
    this.id = '',
    this.email = '',
    this.role = '',
    this.locale = '',
    this.name = '',
    this.disabled,
    this.resigned,
    this.begin,
    this.end,
    this.expire,
    this.created,
    this.updated,
  });

  /// From JSON.
  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  /// To JSON.
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  /// To string.
  @override
  String toString() => "$id [$role] $email, locale=$locale, sign-in=$begin";
}
