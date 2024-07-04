// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';
import 'package:ecinema_mobile/utils/error_snackbar.dart';
import 'package:ecinema_mobile/utils/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  static const String routeName = '/verification';
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late UserProvider userProvider;
  final TextEditingController _tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
  }

  Future<void> _verify() async {
    Map<String, dynamic> verificationReq = {};

    verificationReq['Email'] = widget.email;
    verificationReq['Token'] = int.parse(_tokenController.text.trim());

    try {
      var answer = await userProvider.verify(verificationReq);
      if (answer == 'Ok') {
        showSuccessSnackBar(context, 'Verification successful. Please login.');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const LoginScreen()));
      }
    } catch (e) {
      if (e.toString().contains('Wrong credentials')) {
        showErrorSnackBar(context, 'Wrong token.');
      } else {
        showErrorDialog(context, e.toString().substring(11));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email Address'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter the code you recieved on ${widget.email}:",
                  style: const TextStyle(fontSize: 16, wordSpacing: 1),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _tokenController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      prefixIcon: const Icon(Icons.password, color: darkRedColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      _verify();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      backgroundColor: darkRedColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Verify"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
