import 'dart:convert';

import 'package:flutter/material.dart';

class Authorization {
  static String? username;
  static String? password;
  static int? userId;
}

Image fromBase64String(String image) {
  return Image.memory(
    base64Decode(image),
    width: 150,
    height: 200,
    fit: BoxFit.contain,
  );
}
