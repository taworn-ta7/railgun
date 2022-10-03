// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_signup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberSignUp _$MemberSignUpFromJson(Map<String, dynamic> json) => MemberSignUp(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      locale: json['locale'] as String? ?? '',
      password: json['password'] as String? ?? '',
      confirmPassword: json['confirmPassword'] as String? ?? '',
      confirmToken: json['confirmToken'] as String? ?? '',
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$MemberSignUpToJson(MemberSignUp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'locale': instance.locale,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'confirmToken': instance.confirmToken,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
