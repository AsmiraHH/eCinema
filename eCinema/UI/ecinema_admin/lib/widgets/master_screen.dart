// ignore_for_file: prefer_const_constructors

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/screens/actors_screen.dart';
import 'package:ecinema_admin/screens/cinemas_screen.dart';
import 'package:ecinema_admin/screens/employees_screen.dart';
import 'package:ecinema_admin/screens/genres_screen.dart';
import 'package:ecinema_admin/screens/movies_screen.dart';
import 'package:ecinema_admin/screens/productions_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreen({this.child, this.title, super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
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
        child: ListView(
          children: [
            ListTile(
              title: Text("Movies"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MoviesScreen()));
              },
            ),
            ListTile(
              title: Text("Cinemas"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CinemasScreen()));
              },
            ),
            ListTile(
              title: Text("Genres"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GenresScreen()));
              },
            ),
            ListTile(
              title: Text("Actors"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ActorsScreen()));
              },
            ),
            ListTile(
              title: Text("Employees"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EmployeeScreen()));
              },
            ),
            ListTile(
              title: Text("Productions"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProductionsScreen()));
              },
            )
          ],
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width, minHeight: MediaQuery.sizeOf(context).height),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromARGB(255, 153, 149, 149), // Light gray
                Color.fromARGB(255, 46, 46, 51), // Dark gray
                Color.fromARGB(255, 34, 34, 40), // Charcoal
                Color.fromARGB(255, 9, 9, 10), // Almost Black
                Color.fromARGB(255, 53, 3, 3), // Reddish tone
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
            // color: redColor
            // image: DecorationImage(
            //   image: AssetImage("assets/images/cinemaPic.jpeg"),
            //   fit: BoxFit.cover,
            //   alignment: Alignment.center,
            //   opacity: 50.0,
            //   colorFilter: ColorFilter.mode(
            //     Colors.white.withOpacity(0.9),
            //     BlendMode.dstATop,
            //   ),
            // ),
          ),
          child: widget.child!,
        ),
      ),
    );
  }
}
