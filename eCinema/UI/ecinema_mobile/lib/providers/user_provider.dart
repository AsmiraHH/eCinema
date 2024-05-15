import 'dart:convert';
import 'package:ecinema_mobile/models/user.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  Future<User> login() async {
    var url =
        "$baseUrl$endpoint/Login/${Authorization.username}/${Authorization.password}";
    var uri = Uri.parse(url);

    var headers = createHeaders();
    var req = await http.get(uri, headers: headers);
    if (isValidResponse(req)) {
      var data = jsonDecode(req.body);
      return User.fromJson(data);
    } else {
      throw Exception('Error...');
    }
  }

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
}
