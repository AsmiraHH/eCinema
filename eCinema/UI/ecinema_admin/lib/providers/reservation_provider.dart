import 'package:ecinema_admin/models/reservation.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

  @override
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }
}
