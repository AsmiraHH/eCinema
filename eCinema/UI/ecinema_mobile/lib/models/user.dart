import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? birthDate;
  int? gender;
  int? role;
  bool? isVerified;
  String? profilePhoto;

  User(
      this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.birthDate,
      this.gender,
      this.role,
      this.profilePhoto,
      this.isVerified);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
