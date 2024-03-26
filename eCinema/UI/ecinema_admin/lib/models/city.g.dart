// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      json['id'] as int?,
      json['name'] as String?,
      json['zipCode'] as String?,
      json['countryId'] as int?,
      json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'zipCode': instance.zipCode,
      'countryId': instance.countryId,
      'country': instance.country,
    };
