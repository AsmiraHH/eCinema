// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      (json['id'] as num?)?.toInt(),
      json['isActive'] as bool?,
      json['transactionNumber'] as String?,
      (json['showId'] as num?)?.toInt(),
      json['show'] == null
          ? null
          : Show.fromJson(json['show'] as Map<String, dynamic>),
      (json['seats'] as List<dynamic>?)
          ?.map((e) => ReservationSeat.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['userId'] as num?)?.toInt(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      (json['totalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'transactionNumber': instance.transactionNumber,
      'showId': instance.showId,
      'show': instance.show,
      'userId': instance.userId,
      'user': instance.user,
      'seats': instance.seats,
      'totalPrice': instance.totalPrice,
    };
