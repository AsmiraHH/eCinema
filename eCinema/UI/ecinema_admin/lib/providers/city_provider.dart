import 'package:ecinema_admin/models/city.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("City");

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}
