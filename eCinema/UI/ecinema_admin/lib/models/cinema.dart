import 'package:ecinema_admin/models/city.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cinema.g.dart';

@JsonSerializable()
class Cinema {
  int? id;
  String? name;
  String? address;
  String? email;
  String? phoneNumber;
  int? numberOfHalls;
  int? cityId;
  City? city;

  Cinema(this.id, this.name, this.address, this.email, this.phoneNumber, this.numberOfHalls, this.cityId, this.city);

  factory Cinema.fromJson(Map<String, dynamic> json) => _$CinemaFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaToJson(this);
}
