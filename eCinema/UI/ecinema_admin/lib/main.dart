import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:ecinema_admin/providers/language_provider.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:ecinema_admin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => MovieProvider()),
      ChangeNotifierProvider(create: (_) => GenreProvider()),
      ChangeNotifierProvider(create: (_) => ProductionProvider()),
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ecinema",
      // theme: ThemeData(
      //   textTheme: const TextTheme(
      //     bodyLarge: TextStyle(color: Colors.white),
      //     bodyMedium: TextStyle(color: Colors.white),
      //     bodySmall: TextStyle(color: Colors.white),
      //     titleLarge: TextStyle(color: Colors.white),
      //     titleMedium: TextStyle(color: Colors.white),
      //     titleSmall: TextStyle(color: Colors.white),
      //   ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      // ),
      home: const LoginScreen(),
    );
  }
}
