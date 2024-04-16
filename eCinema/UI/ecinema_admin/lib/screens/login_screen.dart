// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:ecinema_admin/screens/movies_screen.dart';
import 'package:ecinema_admin/utils/util.dart';
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
  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 24, 53),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: 300, maxWidth: 400),
          child: Card(
            color: Colors.white.withOpacity(0.5),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIconColor: Colors.white),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _passwordController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIconColor: Colors.white),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        login(username, password);
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          backgroundColor: Color.fromARGB(255, 16, 24, 53),
                          foregroundColor: Colors.white),
                      child: Text("LOGIN"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(String username, String password) async {
    Authorization.username = username;
    Authorization.password = password;

    try {
      var data = await _userProvider.getRoles(username);
      if (data.contains('Administrator')) {
        Navigator.of(context).push(MaterialPageRoute(builder: (builder) => const MoviesScreen()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Access denied."),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                ));
      }
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
