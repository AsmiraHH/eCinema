// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Production _$ProductionFromJson(Map<String, dynamic> json) => Production(
      json['id'] as int?,
      json['name'] as String?,
      json['countryId'] as int?,
      json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductionToJson(Production instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'countryId': instance.countryId,
      'country': instance.country,
    };
