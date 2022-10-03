import 'package:json_annotation/json_annotation.dart';

part 'member_signup.g.dart';

/// Member sign-up entity.
@JsonSerializable()
class MemberSignUp {
  static const emailMax = 254;
  static const passwordMin = 4;
  static const passwordMax = 20;

  // ----------------------------------------------------------------------

  /// Id.
  int id;

  /// Email.
  String email;

  /// Locale, can be 'en' or 'th'.
  String locale;

  /// Password.
  String password;

  /// Confirm password.
  String confirmPassword;

  /// Confirm token.
  String confirmToken;

  // ----------------------------------------------------------------------

  /// Created date/time.
  DateTime? created;

  /// Updated date/time.
  DateTime? updated;

  /// Constructor.
  MemberSignUp({
    this.id = 0,
    this.email = '',
    this.locale = '',
    this.password = '',
    this.confirmPassword = '',
    this.confirmToken = '',
    this.created,
    this.updated,
  });

  /// From JSON.
  factory MemberSignUp.fromJson(Map<String, dynamic> json) =>
      _$MemberSignUpFromJson(json);

  /// To JSON.
  Map<String, dynamic> toJson() => _$MemberSignUpToJson(this);

  /// To string.
  @override
  String toString() => "$email, locale=$locale";
}
