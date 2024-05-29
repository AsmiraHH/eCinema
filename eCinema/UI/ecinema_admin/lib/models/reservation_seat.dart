import 'package:ecinema_admin/models/reservation.dart';
import 'package:ecinema_admin/models/seat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_seat.g.dart';

@JsonSerializable()
class ReservationSeat {
  Reservation? reservation;
  Seat? seat;

  ReservationSeat(this.reservation, this.seat);

  factory ReservationSeat.fromJson(Map<String, dynamic> json) => _$ReservationSeatFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationSeatToJson(this);
}
