import 'package:ecinema_admin/models/seat.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class SeatProvider extends BaseProvider<Seat> {
  SeatProvider() : super("Seat");

  @override
  Seat fromJson(data) {
    return Seat.fromJson(data);
  }
}
