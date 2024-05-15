import 'dart:io';

import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      // ChangeNotifierProvider(create: (_) => MovieProvider()),
      // ChangeNotifierProvider(create: (_) => GenreProvider()),
      // ChangeNotifierProvider(create: (_) => ProductionProvider()),
      // ChangeNotifierProvider(create: (_) => LanguageProvider()),
      // ChangeNotifierProvider(create: (_) => CinemaProvider()),
      // ChangeNotifierProvider(create: (_) => CityProvider()),
      // ChangeNotifierProvider(create: (_) => CountryProvider()),
      // ChangeNotifierProvider(create: (_) => ActorProvider()),
      // ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      // ChangeNotifierProvider(create: (_) => HallProvider()),
      // ChangeNotifierProvider(create: (_) => ShowProvider()),
      // ChangeNotifierProvider(create: (_) => ReservationProvider()),
      // ChangeNotifierProvider(create: (_) => SeatProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
