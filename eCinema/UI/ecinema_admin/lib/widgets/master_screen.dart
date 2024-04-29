// ignore_for_file: prefer_const_constructors

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/screens/actors_screen.dart';
import 'package:ecinema_admin/screens/cinemas_screen.dart';
import 'package:ecinema_admin/screens/cities_screen.dart';
import 'package:ecinema_admin/screens/countries_screen.dart';
import 'package:ecinema_admin/screens/employees_screen.dart';
import 'package:ecinema_admin/screens/genres_screen.dart';
import 'package:ecinema_admin/screens/halls_screen.dart';
import 'package:ecinema_admin/screens/languages_screen.dart';
import 'package:ecinema_admin/screens/login_screen.dart';
import 'package:ecinema_admin/screens/movies_screen.dart';
import 'package:ecinema_admin/screens/productions_screen.dart';
import 'package:ecinema_admin/screens/report_screen.dart';
import 'package:ecinema_admin/screens/reservations_screen.dart';
import 'package:ecinema_admin/screens/shows_screen.dart';
import 'package:ecinema_admin/screens/users_screen.dart';
import 'package:ecinema_admin/utils/util.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreen({this.child, this.title, super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  void _logOut() {
    Authorization.username = "";
    Authorization.password = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        backgroundColor: blueColor,
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: blueColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("Cinemas"),
                      leading: Icon(Icons.movie_filter),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CinemasScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Halls"),
                      leading: Icon(Icons.meeting_room),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HallsScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Users"),
                      leading: Icon(Icons.people),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UsersScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Employees"),
                      leading: Icon(Icons.people_alt_outlined),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EmployeeScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Movies"),
                      leading: Icon(Icons.movie),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MoviesScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Shows"),
                      leading: Icon(Icons.slideshow),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShowsScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Reservations"),
                      leading: Icon(Icons.calendar_month),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReservationsScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Productions"),
                      leading: Icon(Icons.local_movies),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProductionsScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Actors"),
                      leading: Icon(Icons.recent_actors),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ActorsScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Genres"),
                      leading: Icon(Icons.smart_toy_outlined),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GenresScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Countries"),
                      leading: Icon(Icons.flag_outlined),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CountriesScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Cities"),
                      leading: Icon(Icons.location_city),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CitiesScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Languages"),
                      leading: Icon(Icons.language),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LanguagesScreen()));
                      },
                    ),
                    ListTile(
                      title: Text("Reports"),
                      leading: Icon(Icons.edit_document),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReportScreen()));
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Logout"),
                leading: Icon(Icons.logout),
                onTap: () {
                  _logOut();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width, minHeight: MediaQuery.sizeOf(context).height),
        child: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: const [
            //     Color.fromARGB(255, 153, 149, 149), // Light gray
            //     Color.fromARGB(255, 46, 46, 51), // Dark gray
            //     Color.fromARGB(255, 34, 34, 40), // Charcoal
            //     Color.fromARGB(255, 9, 9, 10), // Almost Black
            //     Color.fromARGB(255, 53, 3, 3), // Reddish tone
            //   ],
            //   stops: const [0.0, 0.15, 0.40, 0.60, 1.0],
            // ),
            image: DecorationImage(
              image: AssetImage("assets/images/cinemaPic.jpeg"),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              opacity: 50.0,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: widget.child!,
        ),
      ),
    );
  }
}
