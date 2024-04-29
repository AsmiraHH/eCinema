import 'dart:convert';

import 'package:ecinema_admin/models/report.dart';
import 'package:ecinema_admin/models/reservation.dart';
import 'package:ecinema_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

  Future<Report> getForReport(dynamic params) async {
    var queryString = getQueryString(params);
    var url = "$baseUrl$endpoint/GetForReport?$queryString";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      var result = Report();
      var data = jsonDecode(req.body);
      result.totalPrice = data['totalPrice'];
      result.totalCount = data['totalCount'];
      result.totalUsers = data['totalUsers'];
      for (var item in data['listOfReservations']) {
        result.listOfReservations.add(fromJson(item));
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
