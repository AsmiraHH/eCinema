import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:flutter/material.dart';

Future<dynamic> showErrorDialog(BuildContext context, String? message) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: darkRedColor),
            SizedBox(width: 10),
            Text('Error', style: TextStyle(color: darkRedColor)),
          ],
        ),
        content: SingleChildScrollView(
          child: Center(
            child: Text(
              message ?? 'An error occurred.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          Center(
            child: MaterialButton(
              color: darkRedColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
