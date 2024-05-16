// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/models/cinema.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/screens/movie_details_screen.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Show> lastAddedShows = <Show>[];
  List<Show> mostWatchedShows = <Show>[];
  late ShowProvider _showProvider;
  late CinemaProvider _cinemaProvider;
  List<Cinema>? cinemasResult;
  int? selectedCinema = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    // loadCinemas();
    loadLastAddedShows();
    loadMostWatchedShows();
  }

  Future<void> loadLastAddedShows() async {
    try {
      var data = await _showProvider.getLastAdded();
      setState(() {
        lastAddedShows = data;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              ));
    }
  }

  Future<void> loadMostWatchedShows() async {
    try {
      var data = await _showProvider.getMostWatched();
      setState(() {
        mostWatchedShows = data;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              ));
    }
  }

  Future<void> loadCinemas() async {
    try {
      var data = await _cinemaProvider.getAll();
      setState(() {
        cinemasResult = data;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          contentPadding:
                              const EdgeInsets.only(top: 10.0, left: 10.0),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Search ...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(width: 3, color: Colors.white)),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                ),
                // Container(
                //     decoration: BoxDecoration(
                //         color: blueColor,
                //         border: Border.all(color: Colors.white),
                //         borderRadius: BorderRadius.circular(8)),
                //     margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
                //     height: 35,
                //     width: MediaQuery.sizeOf(context).width / 2,
                //     child: DropdownButton<int>(
                //       items: [
                //         const DropdownMenuItem<int>(
                //           value: 0,
                //           child: Text('All'),
                //         ),
                //         ...cinemasResult
                //                 ?.map((e) => DropdownMenuItem(
                //                       value: e.id,
                //                       child: Text(
                //                         e.name!,
                //                       ),
                //                     ))
                //                 .toList() ??
                //             [],
                //       ],
                //       value: selectedCinema,
                //       onChanged: (int? newValue) {
                //         setState(() {
                //           selectedCinema = newValue;
                //           loadLastAddedShows();
                //         });
                //       },
                //       isExpanded: true,
                //       padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                //       underline: Container(),
                //       style: const TextStyle(color: Colors.white),
                //     )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Last added movies',
              textAlign: TextAlign.start,
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            if (loading == false) buildShows(lastAddedShows),
            const Text(
              'Popular movies',
              textAlign: TextAlign.start,
            ),
            if (loading == false) buildShows(mostWatchedShows),
          ],
        ),
      ),
    );
  }
}

Widget buildShows(List<Show> shows) {
  return Expanded(
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      itemCount: shows.length,
      itemBuilder: (context, index) {
        return buildShow(context, shows[index]);
      },
    ),
  );
}

Widget buildShow(BuildContext context, Show show) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (builder) => MovieDetailsScreen(show: show)));
    },
    child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
        child: Expanded(
          child: show.movie!.photo != ""
              ? fromBase64String(show.movie!.photo!)
              : const Icon(Icons.photo, size: 40, color: Colors.white),
        )),
  );
}
