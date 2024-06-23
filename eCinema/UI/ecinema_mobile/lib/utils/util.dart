import 'dart:convert';

import 'package:ecinema_mobile/models/user.dart';
import 'package:flutter/material.dart';

class Authorization {
  static String? username;
  static String? password;
  static int? userId;
  static User? user;
}

Image fromBase64String(String image) {
  return Image.memory(
    base64Decode(image),
    width: 150,
    height: 200,
    fit: BoxFit.cover,
  );
}

Image fromBase64StringR(String image) {
  return Image.memory(
    base64Decode(image),
    width: 250,
    height: 150,
    fit: BoxFit.cover,
  );
}

Image fromBase64StringCover(String image) {
  return Image.memory(
    base64Decode(image),
    fit: BoxFit.cover,
    color: Colors.black.withOpacity(0.5),
    colorBlendMode: BlendMode.dstATop,
  );
}

Image fromBase64StringCoverWithoutOpacity(String image) {
  return Image.memory(
    base64Decode(image),
    fit: BoxFit.cover,
  );
}
