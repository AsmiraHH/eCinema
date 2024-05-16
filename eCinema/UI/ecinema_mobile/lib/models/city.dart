import 'package:ecinema_mobile/models/country.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  int? id;
  String? name;
  String? zipCode;
  int? countryId;
  Country? country;

  City(this.id, this.name, this.zipCode, this.countryId, this.country);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
