import 'package:json_annotation/json_annotation.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  int? gender;
  String? birthDate;

  Actor(this.id, this.firstName, this.lastName, this.email, this.gender, this.birthDate);

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);

  Map<String, dynamic> toJson() => _$ActorToJson(this);
}
