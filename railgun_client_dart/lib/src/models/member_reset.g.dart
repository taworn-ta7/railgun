// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_reset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberReset _$MemberResetFromJson(Map<String, dynamic> json) => MemberReset(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      confirmToken: json['confirmToken'] as String? ?? '',
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$MemberResetToJson(MemberReset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'confirmToken': instance.confirmToken,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
