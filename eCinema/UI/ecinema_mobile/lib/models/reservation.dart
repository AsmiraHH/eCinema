import 'package:ecinema_mobile/models/reservation_seat.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int? id;
  bool? isActive;
  String? transactionNumber;
  int? showId;
  Show? show;
  int? userId;
  User? user;
  List<ReservationSeat>? seats;
  double? totalPrice;

  Reservation(this.id, this.isActive, this.transactionNumber, this.showId, this.show, this.seats, this.userId,
      this.user, this.totalPrice);

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
