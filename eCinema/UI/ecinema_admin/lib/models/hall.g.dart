// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hall _$HallFromJson(Map<String, dynamic> json) => Hall(
      json['id'] as int?,
      json['name'] as String?,
      json['numberOfSeats'] as int?,
      (json['formats'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['cinemaId'] as int?,
      json['cinema'] == null
          ? null
          : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HallToJson(Hall instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'numberOfSeats': instance.numberOfSeats,
      'formats': instance.formats,
      'cinemaId': instance.cinemaId,
      'cinema': instance.cinema,
    };
