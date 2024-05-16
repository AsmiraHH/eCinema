// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cinema _$CinemaFromJson(Map<String, dynamic> json) => Cinema(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['address'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      (json['numberOfHalls'] as num?)?.toInt(),
      (json['cityId'] as num?)?.toInt(),
      json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CinemaToJson(Cinema instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'numberOfHalls': instance.numberOfHalls,
      'cityId': instance.cityId,
      'city': instance.city,
    };
