import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/hall.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'show.g.dart';

@JsonSerializable()
class Show {
  int? id;
  String? date;
  String? startTime;
  int? format;
  int? price;
  int? hallId;
  Hall? hall;
  int? cinemaId;
  Cinema? cinema;
  int? movieId;
  Movie? movie;

  Show(this.id, this.date, this.startTime, this.format, this.price, this.hallId, this.hall, this.cinemaId, this.cinema,
      this.movieId, this.movie);

  factory Show.fromJson(Map<String, dynamic> json) => _$ShowFromJson(json);

  Map<String, dynamic> toJson() => _$ShowToJson(this);
}
