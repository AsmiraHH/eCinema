import 'dart:convert';
import '../models/user.dart';
import 'package:ecinema_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  Future<List<String>> getRoles(String username) async {
    var url = "$baseUrl$endpoint/GetRoles/$username";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      List<String> roles = [];
      var data = jsonDecode(req.body);
      for (var item in data) {
        roles.add(item);
      }
      return roles;
    } else {
      throw Exception("Error while fetching roles.");
    }
  }
}
