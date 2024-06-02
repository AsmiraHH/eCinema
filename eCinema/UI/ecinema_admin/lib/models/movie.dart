import 'package:ecinema_admin/models/language.dart';
import 'package:ecinema_admin/models/movie_actor.dart';
import 'package:ecinema_admin/models/movie_genre.dart';
import 'package:ecinema_admin/models/production.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  int? id;
  String? title;
  String? description;
  String? author;
  int? duration;
  int? releaseYear;
  int? productionId;
  Production? production;
  int? languageId;
  Language? language;
  List<int>? genreIDs;
  List<int>? actorIDs;
  List<MovieGenre>? genres;
  List<MovieActor>? actors;
  String? photo;

  Movie(this.id, this.title, this.description, this.releaseYear, this.productionId, this.languageId, this.photo, this.genreIDs,
      this.genres, this.actorIDs, this.actors);

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
