import 'package:json_annotation/json_annotation.dart';

part 'member_reset.g.dart';

/// Member sign-up entity.
@JsonSerializable()
class MemberReset {
  static const emailMax = 254;

  // ----------------------------------------------------------------------

  /// Id.
  int id;

  /// Email.
  String email;

  /// Confirm token.
  String confirmToken;

  // ----------------------------------------------------------------------

  /// Created date/time.
  DateTime? created;

  /// Updated date/time.
  DateTime? updated;

  /// Constructor.
  MemberReset({
    this.id = 0,
    this.email = '',
    this.confirmToken = '',
    this.created,
    this.updated,
  });

  /// From JSON.
  factory MemberReset.fromJson(Map<String, dynamic> json) =>
      _$MemberResetFromJson(json);

  /// To JSON.
  Map<String, dynamic> toJson() => _$MemberResetToJson(this);

  /// To string.
  @override
  String toString() => email;
}
