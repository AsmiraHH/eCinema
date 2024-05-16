import 'package:ecinema_mobile/models/cinema.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hall.g.dart';

@JsonSerializable()
class Hall {
  int? id;
  String? name;
  int? numberOfSeats;
  int? numberOfRows;
  int? maxNumberOfSeatsPerRow;
  List<int>? formats;
  int? cinemaId;
  Cinema? cinema;

  Hall(this.id, this.name, this.numberOfSeats, this.numberOfRows,
      this.maxNumberOfSeatsPerRow, this.formats, this.cinemaId, this.cinema);

  factory Hall.fromJson(Map<String, dynamic> json) => _$HallFromJson(json);

  Map<String, dynamic> toJson() => _$HallToJson(this);
}
