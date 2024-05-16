// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hall _$HallFromJson(Map<String, dynamic> json) => Hall(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      (json['numberOfSeats'] as num?)?.toInt(),
      (json['numberOfRows'] as num?)?.toInt(),
      (json['maxNumberOfSeatsPerRow'] as num?)?.toInt(),
      (json['formats'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      (json['cinemaId'] as num?)?.toInt(),
      json['cinema'] == null
          ? null
          : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HallToJson(Hall instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'numberOfSeats': instance.numberOfSeats,
      'numberOfRows': instance.numberOfRows,
      'maxNumberOfSeatsPerRow': instance.maxNumberOfSeatsPerRow,
      'formats': instance.formats,
      'cinemaId': instance.cinemaId,
      'cinema': instance.cinema,
    };
