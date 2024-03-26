import 'package:ecinema_admin/models/seat.dart';
import 'package:ecinema_admin/models/show.dart';
import 'package:ecinema_admin/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int? id;
  bool? isActive;
  int? showId;
  Show? show;
  int? seatId;
  Seat? seat;
  int? userId;
  User? user;

  Reservation(this.id, this.isActive, this.showId, this.show, this.seatId, this.seat, this.userId, this.user);

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
