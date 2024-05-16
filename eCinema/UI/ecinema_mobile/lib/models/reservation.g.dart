// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      (json['id'] as num?)?.toInt(),
      json['isActive'] as bool?,
      (json['showId'] as num?)?.toInt(),
      json['show'] == null
          ? null
          : Show.fromJson(json['show'] as Map<String, dynamic>),
      (json['seatId'] as num?)?.toInt(),
      json['seat'] == null
          ? null
          : Seat.fromJson(json['seat'] as Map<String, dynamic>),
      (json['userId'] as num?)?.toInt(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'showId': instance.showId,
      'show': instance.show,
      'seatId': instance.seatId,
      'seat': instance.seat,
      'userId': instance.userId,
      'user': instance.user,
    };
