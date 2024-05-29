// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationSeat _$ReservationSeatFromJson(Map<String, dynamic> json) =>
    ReservationSeat(
      json['reservation'] == null
          ? null
          : Reservation.fromJson(json['reservation'] as Map<String, dynamic>),
      json['seat'] == null
          ? null
          : Seat.fromJson(json['seat'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationSeatToJson(ReservationSeat instance) =>
    <String, dynamic>{
      'reservation': instance.reservation,
      'seat': instance.seat,
    };
