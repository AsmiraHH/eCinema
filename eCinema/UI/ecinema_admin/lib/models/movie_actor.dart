import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_actor.g.dart';

@JsonSerializable()
class MovieActor {
  Movie? movie;
  Actor? actor;

  MovieActor(this.movie, this.actor);

  factory MovieActor.fromJson(Map<String, dynamic> json) => _$MovieActorFromJson(json);

  Map<String, dynamic> toJson() => _$MovieActorToJson(this);
}
