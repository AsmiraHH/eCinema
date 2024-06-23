import 'package:ecinema_mobile/models/hall.dart';
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Seat && other.id == id;
  }

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
