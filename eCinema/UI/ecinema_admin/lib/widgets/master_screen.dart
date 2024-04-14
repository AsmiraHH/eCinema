// ignore_for_file: prefer_const_constructors

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/screens/cinemas_screen.dart';
import 'package:ecinema_admin/screens/movies_screen.dart';
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
            )
          ],
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width, minHeight: MediaQuery.sizeOf(context).height),
        child: Container(
          decoration: BoxDecoration(
            color: redColor, // Dark background color
            // image: DecorationImage(
            //   image: AssetImage("assets/images/cinemaPic.jpeg"),
            //   fit: BoxFit.cover,
            //   alignment: Alignment.center,
            //   // colorFilter: ColorFilter.mode(
            //   //   Colors.white.withOpacity(0.9),
            //   //   BlendMode.dstATop,
            //   // ),
            // ),
          ),
          child: widget.child!,
        ),
      ),
    );
  }
}
