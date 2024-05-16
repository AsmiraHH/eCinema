import 'dart:convert';

import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ShowProvider extends BaseProvider<Show> {
  ShowProvider() : super("Show");

  Future<List<Show>> getLastAdded() async {
    var url = "$baseUrl$endpoint/GetLastAdded";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      List<Show> result = [];
      var data = jsonDecode(req.body);
      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Error");
    }
  }

  Future<List<Show>> getMostWatched() async {
    var url = "$baseUrl$endpoint/GetMostWatched";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      List<Show> result = [];
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
  Show fromJson(data) {
    return Show.fromJson(data);
  }
}
