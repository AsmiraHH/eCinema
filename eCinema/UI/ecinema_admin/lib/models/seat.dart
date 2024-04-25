import 'package:ecinema_admin/models/hall.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  int? id;
  String? row;
  int? column;
  int? hallId;
  Hall? hall;
  bool? isDisabled;
  bool? isSelected = false;

  Seat(this.id, this.row, this.column, this.hallId, this.hall, this.isDisabled, this.isSelected);

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
