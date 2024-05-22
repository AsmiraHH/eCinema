import 'dart:io';

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/actor_provider.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/city_provider.dart';
import 'package:ecinema_mobile/providers/country_provider.dart';
import 'package:ecinema_mobile/providers/genre_provider.dart';
import 'package:ecinema_mobile/providers/hall_provider.dart';
import 'package:ecinema_mobile/providers/language_provider.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:ecinema_mobile/providers/production_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/providers/seat_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/change_password_screen.dart';
import 'package:ecinema_mobile/screens/home_page.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:ecinema_mobile/screens/movie_details_screen.dart';
import 'package:ecinema_mobile/screens/movies_screen.dart';
import 'package:ecinema_mobile/screens/profile_screen.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => MovieProvider()),
      ChangeNotifierProvider(create: (_) => GenreProvider()),
      ChangeNotifierProvider(create: (_) => ProductionProvider()),
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => CinemaProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
      ChangeNotifierProvider(create: (_) => CountryProvider()),
      ChangeNotifierProvider(create: (_) => ActorProvider()),
      ChangeNotifierProvider(create: (_) => HallProvider()),
      ChangeNotifierProvider(create: (_) => ShowProvider()),
      ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ChangeNotifierProvider(create: (_) => SeatProvider()),
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
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white),
          ).apply(bodyColor: Colors.white, displayColor: Colors.white, decorationColor: Colors.white),
        ),
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
          // RegisterScreen.routeName: (context) => const RegisterScreen(),
          // CinemaScreen.routeName: (context) => const CinemaScreen(),
          // PaymentScreen.routeName: (context) => const PaymentScreen(),
          // EditProfileScreen.routeName: (context) => const EditProfileScreen()
        },
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailsScreen.routeName) {
            return MaterialPageRoute(builder: (context) => MovieDetailsScreen(show: settings.arguments as Show));
          }
          if (settings.name == '/') {
            return MaterialPageRoute(
                builder: (context) => NavBar(index: settings.arguments != null ? settings.arguments as int : 0));
          }
          return null;
        });
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key, this.index = 0});

  final int index;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Widget> screens = [const HomePage(), const MoviesScreen(), const ProfileScreen()];

  late int _selectedIndex;
  // late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    // userProvider = context.read<UserProvider>();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int? user = Authorization.userId;
    if (user == null) {
      return const LoginScreen();
    }
    // User? user = userProvider.user;
    // if (user == null) {
    //   return const LoginScreen();
    // }
    else {
      return SafeArea(
        child: Scaffold(
          body: screens.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.theaters,
                ),
                label: 'Movies',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            backgroundColor: darkRedColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      );
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
