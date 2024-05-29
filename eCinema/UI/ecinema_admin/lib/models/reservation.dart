import 'package:ecinema_admin/models/reservation_seat.dart';
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
  int? userId;
  User? user;
  List<ReservationSeat>? seats;

  Reservation(this.id, this.isActive, this.showId, this.show, this.seats, this.userId, this.user);

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
