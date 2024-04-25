// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      json['id'] as int?,
      json['row'] as String?,
      json['column'] as int?,
      json['hallId'] as int?,
      json['hall'] == null
          ? null
          : Hall.fromJson(json['hall'] as Map<String, dynamic>),
      json['isDisabled'] as bool?,
      json['isSelected'] as bool?,
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'id': instance.id,
      'row': instance.row,
      'column': instance.column,
      'hallId': instance.hallId,
      'hall': instance.hall,
      'isDisabled': instance.isDisabled,
      'isSelected': instance.isSelected,
    };
