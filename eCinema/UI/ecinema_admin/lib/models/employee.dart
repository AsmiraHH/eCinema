import 'package:ecinema_admin/models/cinema.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? birthDate;
  int? gender;
  bool? isActive;
  String? profilePhoto;
  int? cinemaId;
  Cinema? cinema;

  Employee(this.id, this.firstName, this.lastName, this.email, this.phoneNumber, this.birthDate, this.gender,
      this.isActive, this.profilePhoto, this.cinemaId, this.cinema);

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
