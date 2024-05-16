import 'package:ecinema_mobile/models/hall.dart';
import 'package:ecinema_mobile/models/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'show.g.dart';

@JsonSerializable()
class Show {
  int? id;
  String? dateTime;
  String? format;
  int? price;
  int? hallId;
  Hall? hall;
  int? movieId;
  Movie? movie;

  Show(this.id, this.dateTime, this.format, this.price, this.hallId, this.hall,
      this.movieId, this.movie);

  factory Show.fromJson(Map<String, dynamic> json) => _$ShowFromJson(json);

  Map<String, dynamic> toJson() => _$ShowToJson(this);
}
