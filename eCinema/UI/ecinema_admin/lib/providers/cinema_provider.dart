import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class CinemaProvider extends BaseProvider<Cinema> {
  CinemaProvider() : super("Cinema");

  @override
  Cinema fromJson(data) {
    return Cinema.fromJson(data);
  }
}
