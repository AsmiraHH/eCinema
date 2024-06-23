import 'dart:convert';

import 'package:ecinema_mobile/helpers/global_variables.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:http/http.dart' as http;

class ShowProvider extends BaseProvider<Show> {
  ShowProvider() : super("Show");

  Future<List<Show>> getByMovieId(int? movieId, bool isDistinct) async {
    var url = "$baseUrl$endpoint/GetByMovieId/$movieId/$cinema/$isDistinct";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      List<Show> result = [];
      var data = jsonDecode(response.body);
      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception('Error...');
    }
  }

  Future<List<Show>> getRecommended(int selectedCinema) async {
    var url = "$baseUrl$endpoint/GetRecommended/$selectedCinema/${Authorization.userId}";
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
