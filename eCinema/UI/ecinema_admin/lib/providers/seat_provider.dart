import 'dart:convert';

import 'package:ecinema_admin/models/seat.dart';
import 'package:ecinema_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class SeatProvider extends BaseProvider<Seat> {
  SeatProvider() : super("Seat");

  Future<List<Seat>> getByHallId(int? hallId) async {
    var url = "$baseUrl$endpoint/GetByHallId/$hallId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      List<Seat> result = [];
      var data = jsonDecode(req.body);
      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Error");
    }
  }

  Future<Seat> disable(List<Seat>? seats) async {
    var url = "$baseUrl$endpoint/Disable";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var obj = jsonEncode(seats);
    var response = await http.put(uri, headers: headers, body: obj);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Error...');
    }
  }

  @override
  Seat fromJson(data) {
    return Seat.fromJson(data);
  }
}
