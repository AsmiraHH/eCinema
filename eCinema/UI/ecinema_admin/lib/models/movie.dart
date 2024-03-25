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
  // Production? production;
  int? languageId;
  // Language? language;
  String? photo;

  Movie(this.id, this.title, this.description, this.releaseYear, this.productionId, this.languageId, this.photo);

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
