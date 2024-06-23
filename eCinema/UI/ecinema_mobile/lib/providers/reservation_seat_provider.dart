import 'dart:convert';

import 'package:ecinema_mobile/models/reservation_seat.dart';
import 'package:ecinema_mobile/models/seat.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:ecinema_mobile/providers/seat_provider.dart';
import 'package:http/http.dart' as http;

class ReservationSeatProvider extends BaseProvider<ReservationSeat> {
  final SeatProvider _seatProvider = SeatProvider();

  ReservationSeatProvider() : super("ReservationSeat");

  Future<List<Seat>> getByShowId(int? showId) async {
    var url = "$baseUrl$endpoint/GetByShowId/$showId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      List<Seat> result = [];
      var data = jsonDecode(req.body);
      for (var item in data) {
        result.add(_seatProvider.fromJson(item));
      }
      return result;
    } else {
      throw Exception("Error");
    }
  }

  @override
  ReservationSeat fromJson(data) {
    return ReservationSeat.fromJson(data);
  }
}
