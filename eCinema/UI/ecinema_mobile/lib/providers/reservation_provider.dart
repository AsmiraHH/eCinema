import 'dart:convert';

import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

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
