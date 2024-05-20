// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/home_page.dart';
import 'package:ecinema_mobile/screens/registration_screen.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late UserProvider _userProvider;
  bool _obscurePassword = true;
  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/cinemaPic.jpeg",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 350),
              child: Card(
                color: Colors.white.withOpacity(0.6),
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_pin,
                        size: 60,
                      ),
                      TextField(
                        controller: _usernameController,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.person),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIconColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                          controller: _passwordController,
                          cursorColor: Colors.white,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.password),
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIconColor: Colors.white,
                            suffixIcon: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: _obscurePassword
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(Icons.visibility_off_outlined)),
                          )),
                      SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            String username = _usernameController.text;
                            String password = _passwordController.text;
                            login(username, password);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(35),
                            backgroundColor: Color.fromARGB(255, 16, 24, 53),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text("LOGIN"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(builder: (builder) => const RegistrationScreen()));
                            },
                            child: const Text("Sign Up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login(String username, String password) async {
    Authorization.username = username;
    Authorization.password = password;

    try {
      var data = await _userProvider.login();
      Authorization.userId = data.id;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const HomePage()));
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
              ));
    }
  }
}
