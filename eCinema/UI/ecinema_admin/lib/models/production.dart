import 'package:ecinema_admin/models/country.dart';
import 'package:json_annotation/json_annotation.dart';

part 'production.g.dart';

@JsonSerializable()
class Production {
  int? id;
  String? name;
  int? countryId;
  Country? country;

  Production(this.id, this.name, this.countryId, this.country);

  factory Production.fromJson(Map<String, dynamic> json) => _$ProductionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionToJson(this);
}
