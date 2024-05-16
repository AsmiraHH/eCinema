import 'package:ecinema_mobile/models/genre.dart';
import 'package:ecinema_mobile/models/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_genre.g.dart';

@JsonSerializable()
class MovieGenre {
  Movie? movie;
  Genre? genre;

  MovieGenre(this.movie, this.genre);

  factory MovieGenre.fromJson(Map<String, dynamic> json) =>
      _$MovieGenreFromJson(json);

  Map<String, dynamic> toJson() => _$MovieGenreToJson(this);
}
