// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      locale: json['locale'] as String? ?? '',
      name: json['name'] as String? ?? '',
      disabled: json['disabled'] == null
          ? null
          : DateTime.parse(json['disabled'] as String),
      resigned: json['resigned'] == null
          ? null
          : DateTime.parse(json['resigned'] as String),
      begin: json['begin'] == null
          ? null
          : DateTime.parse(json['begin'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      expire: json['expire'] == null
          ? null
          : DateTime.parse(json['expire'] as String),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'locale': instance.locale,
      'name': instance.name,
      'disabled': instance.disabled?.toIso8601String(),
      'resigned': instance.resigned?.toIso8601String(),
      'begin': instance.begin?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'expire': instance.expire?.toIso8601String(),
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
