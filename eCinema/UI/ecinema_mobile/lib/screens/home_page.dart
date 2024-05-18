// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/models/cinema.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/screens/movie_details_screen.dart';
import 'package:ecinema_mobile/screens/movies_screen.dart';
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
  final TextEditingController _searchController = TextEditingController();

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 45,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesScreen(
                                  movieName: _searchController.text)),
                        );
                      },
                      child: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Search ...',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onSubmitted: (String value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MoviesScreen(movieName: value)),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Last Added Movies',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              if (loading == false) buildShows(lastAddedShows),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Popular Movies',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              if (loading == false) buildShows(mostWatchedShows),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildShows(List<Show> shows) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      crossAxisCount: 3,
      childAspectRatio: 0.7,
    ),
    itemCount: shows.length,
    itemBuilder: (context, index) {
      return buildShow(context, shows[index]);
    },
  );
}

Widget buildShow(BuildContext context, Show show) {
  return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => MovieDetailsScreen(show: show)));
      },
      child: Expanded(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: show.movie!.photo != ""
            ? fromBase64String(show.movie!.photo!)
            : const Icon(Icons.photo, size: 40, color: Colors.white),
      )));
}
