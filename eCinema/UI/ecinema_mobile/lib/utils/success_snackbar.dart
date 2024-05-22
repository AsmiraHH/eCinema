// ignore_for_file: file_names

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:flutter/material.dart';

Future<dynamic> showSuccessSnackBar(BuildContext context, String message) async {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: blueColor,
        content: Center(
          child: Text(message,
              style: const TextStyle(
                color: Colors.white,
              )),
        )),
  );
}
