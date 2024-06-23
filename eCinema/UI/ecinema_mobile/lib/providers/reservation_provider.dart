import 'dart:convert';

import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/models/seat.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

  Show? _selectedShow;

  setSelectedShow(Show? show) {
    _selectedShow = show;
  }

  Show? get selectedShow => _selectedShow;

  var _selectedSeats = <Seat>[];

  setSelectedSeats(List<Seat> seats) {
    _selectedSeats = seats;
  }

  List<Seat> get selectedSeats => _selectedSeats;

  get totalPrice => _selectedShow!.price! * _selectedSeats.length;

  Future<List<Reservation>> getByUserId(int? userId) async {
    var url = "$baseUrl$endpoint/GetByUserID/$userId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      List<Reservation> result = [];
      var data = jsonDecode(req.body);
      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Error");
    }
  }

  @override
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }
}
