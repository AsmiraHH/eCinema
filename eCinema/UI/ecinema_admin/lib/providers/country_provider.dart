import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super("Country");

  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }
}
