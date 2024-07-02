import 'dart:convert';
import 'package:ecinema_mobile/models/user.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  Future<User> login() async {
    var url = "$baseUrl$endpoint/Login/${Authorization.username}/${Authorization.password}";
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
  Future<User> insert(dynamic object) async {
    var url = "$baseUrl$endpoint/Post";
    var uri = Uri.parse(url);
    var headers = {'Content-Type': 'application/json'};

    var obj = jsonEncode(object);
    var response = await http.post(uri, headers: headers, body: obj);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Error...');
    }
  }

  Future<User> updateProfileImage(dynamic object) async {
    var url = "$baseUrl$endpoint/UpdateProfileImage";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var obj = jsonEncode(object);
    var response = await http.put(uri, headers: headers, body: obj);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Error...');
    }
  }

  Future changePassword(dynamic object) async {
    var url = "$baseUrl$endpoint/ChangePassword";
    var uri = Uri.parse(url);
    var obj = jsonEncode(object);

    var headers = createHeaders();
    var response = await http.put(uri, headers: headers, body: obj);

    if (isValidResponse(response)) {
      return 'Ok';
    } else {
      throw Exception('Error...');
    }
  }

  Future verify(dynamic object) async {
    var url = "$baseUrl$endpoint/Verify";
    var uri = Uri.parse(url);
    var headers = {'Content-Type': 'application/json'};

    var obj = jsonEncode(object);
    var response = await http.put(uri, headers: headers, body: obj);

    if (isValidResponse(response)) {
      return 'Ok';
    } else {
      throw Exception('Error...');
    }
  }

  void logout() {
    Authorization.userId = null;
    Authorization.user = null;
    Authorization.username = null;
    Authorization.password = null;
  }

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
}
