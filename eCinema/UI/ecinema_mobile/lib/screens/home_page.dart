// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/global_variables.dart';
import 'package:ecinema_mobile/models/cinema.dart';
import 'package:ecinema_mobile/models/movie.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
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
  List<Movie> lastAddedShows = <Movie>[];
  List<Movie> mostWatchedShows = <Movie>[];
  List<Movie> recommendedShows = <Movie>[];
  late CinemaProvider _cinemaProvider;
  late MovieProvider _movieProvider;
  List<Cinema> cinemasResult = <Cinema>[];
  int selectedCinema = cinema;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cinemaProvider = context.read<CinemaProvider>();
    _movieProvider = context.read<MovieProvider>();
    loadCinemas();
    loadShows();
  }

  Future<void> loadShows() async {
    _isLoading = true;
    try {
      await loadMostWatchedShows();
      await loadRecommendedShows();
      await loadLastAddedShows();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  Future<void> loadLastAddedShows() async {
    try {
      var data = await _movieProvider.getLastAdded(selectedCinema);
      if (mounted) {
        setState(() {
          lastAddedShows = data;
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  Future<void> loadMostWatchedShows() async {
    try {
      var data = await _movieProvider.getMostWatched(selectedCinema);
      if (mounted) {
        setState(() {
          mostWatchedShows = data;
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  Future<void> loadRecommendedShows() async {
    try {
      var data = await _movieProvider.getRecommended(selectedCinema);
      if (mounted) {
        setState(() {
          recommendedShows = data;
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  Future<void> loadCinemas() async {
    try {
      var data = await _cinemaProvider.getAll();
      if (mounted) {
        setState(() {
          cinemasResult = data;
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: DropdownButton<int>(
                items: [
                  ...cinemasResult.map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(
                          e.name!,
                        ),
                      ))
                ],
                value: selectedCinema,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedCinema = newValue ?? 1;
                    cinema = selectedCinema;
                    lastAddedShows = [];
                    mostWatchedShows = [];
                    recommendedShows = [];
                    loadShows();
                  });
                },
                isExpanded: false,
                underline: Container(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                            MaterialPageRoute(builder: (context) => MoviesScreen(movieName: _searchController.text)),
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
                        MaterialPageRoute(builder: (context) => MoviesScreen(movieName: value)),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Recommended Movies',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildMovies(recommendedShows),
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
                buildMovies(lastAddedShows),
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
                buildMovies(mostWatchedShows),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget buildMovies(List<Movie> movies) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        children: List.generate(movies.length, (index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 3 - 20,
            child: buildMovie(context, movies[index]),
          );
        }),
      ),
    );
  }
}

Widget buildMovie(BuildContext context, Movie movie) {
  return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (builder) => MovieDetailsScreen(movie: movie)));
      },
      child: Expanded(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:
            movie.photo != "" ? fromBase64String(movie.photo!) : const Icon(Icons.photo, size: 40, color: Colors.white),
      )));
}
