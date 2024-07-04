// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      json['id'] as int?,
      json['isActive'] as bool?,
      json['showId'] as int?,
      json['show'] == null
          ? null
          : Show.fromJson(json['show'] as Map<String, dynamic>),
      (json['seats'] as List<dynamic>?)
          ?.map((e) => ReservationSeat.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['userId'] as int?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['transactionNumber'] as String?,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'showId': instance.showId,
      'show': instance.show,
      'userId': instance.userId,
      'user': instance.user,
      'seats': instance.seats,
      'transactionNumber': instance.transactionNumber,
    };
