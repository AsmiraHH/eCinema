// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/models/cinema.dart';
import 'package:ecinema_mobile/models/genre.dart';
import 'package:ecinema_mobile/models/paged_result.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/genre_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/screens/movie_details_screen.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  final String? movieName;

  const MoviesScreen({super.key, this.movieName});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int _currentPage = 1;
  final _pageSize = 9;
  PagedResult<Show>? showsResult;
  late ShowProvider _showProvider;
  late CinemaProvider _cinemaProvider;
  late GenreProvider _genreProvider;
  List<Cinema> cinemasResult = [];
  List<Genre> genresResult = [];
  int? selectedCinema = 0;
  int? selectedGenre = 0;
  bool loading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _genreProvider = context.read<GenreProvider>();
    loadCinemas();
    loadGenres();
    loadShows({
      'PageNumber': _currentPage,
      'PageSize': _pageSize,
      'Movie': widget.movieName ?? "",
    });
  }

  Future<void> loadShows(dynamic request) async {
    try {
      var data = await _showProvider.getPaged(request);
      setState(() {
        showsResult = data;
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

  Future<void> loadGenres() async {
    try {
      var data = await _genreProvider.getAll();
      setState(() {
        genresResult = data;
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
      appBar: AppBar(title: const Text('Movies')),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              showsResult = PagedResult<Show>();
                              loadShows({
                                'PageNumber': _currentPage,
                                'PageSize': _pageSize,
                                'Movie': _searchController.text,
                                'Cinema': selectedCinema,
                                'Genre': selectedGenre,
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: 'Search ...',
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        onSubmitted: (String value) {
                          showsResult = PagedResult<Show>();
                          loadShows({
                            'PageNumber': _currentPage,
                            'PageSize': _pageSize,
                            'Movie': _searchController.text,
                            'Cinema': selectedCinema,
                            'Genre': selectedGenre,
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Cinema',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: DropdownButton<int>(
                        items: [
                          const DropdownMenuItem<int>(
                            value: 0,
                            child: Text('All'),
                          ),
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
                            selectedCinema = newValue;
                            showsResult = PagedResult<Show>();
                            loadShows({
                              'PageNumber': _currentPage,
                              'PageSize': _pageSize,
                              'Movie': _searchController.text,
                              'Cinema': selectedCinema,
                              'Genre': selectedGenre,
                            });
                          });
                        },
                        isExpanded: true,
                        underline: Container(),
                        style: const TextStyle(color: Colors.grey),
                        // dropdownColor: Colors.black,
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     margin: const EdgeInsets.only(left: 30, top: 10),
                    //     height: 40,
                    //     child: TextField(
                    //       controller: _searchController,
                    //       decoration: InputDecoration(
                    //         suffixIcon: GestureDetector(
                    //           onTap: () {
                    //             showsResult = PagedResult<Show>();
                    //             loadShows({
                    //               'PageNumber': _currentPage,
                    //               'PageSize': _pageSize,
                    //               'Movie': _searchController.text,
                    //               'Cinema': selectedCinema,
                    //               'Genre': selectedGenre,
                    //             });
                    //           },
                    //           child: const Icon(
                    //             Icons.search,
                    //             color: Colors.grey,
                    //           ),
                    //         ),
                    //         hintText: 'Search ...',
                    //         hintStyle: const TextStyle(
                    //             color: Colors.grey, fontSize: 15),
                    //       ),
                    //       onSubmitted: (String value) {
                    //         showsResult = PagedResult<Show>();
                    //         loadShows({
                    //           'PageNumber': _currentPage,
                    //           'PageSize': _pageSize,
                    //           'Movie': _searchController.text,
                    //           'Cinema': selectedCinema,
                    //           'Genre': selectedGenre,
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // ],
                    // ),
                    buildGenres(),
                    const SizedBox(height: 10),
                    buildShows(showsResult),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildPagination(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(55, 35),
              padding: const EdgeInsets.all(1),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15))),
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                    showsResult = PagedResult<Show>();
                  });
                  loadShows({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
                    'Genre': selectedGenre,
                  });
                }
              : null,
          child: const Icon(
            Icons.arrow_left_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(55, 35),
              padding: const EdgeInsets.all(1),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15))),
          onPressed: showsResult?.hasNextPage ?? false
              ? () {
                  setState(() {
                    _currentPage++;
                    showsResult = PagedResult<Show>();
                  });
                  loadShows({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
                    'Genre': selectedGenre,
                  });
                }
              : null,
          child: const Icon(
            Icons.arrow_right_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  buildGenres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: genresResult!.map((genre) {
              bool isSelected = selectedGenre == genre.id;
              return ChoiceChip(
                label: Text(genre.name.toString()),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    if (isSelected) {
                      selectedGenre = 0;
                    } else {
                      selectedGenre = genre.id;
                    }
                  });
                  showsResult = PagedResult<Show>();
                  loadShows({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
                    'Genre': selectedGenre,
                  });
                },
                selectedColor: Colors.red,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                ),
                backgroundColor: Colors.transparent,
                shape: const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none),
                ),
                labelPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

Widget buildShows(PagedResult<Show>? shows) {
  if (shows != null) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      itemCount: shows.items.length,
      itemBuilder: (context, index) {
        return buildShow(context, shows.items[index]);
      },
    );
  } else {
    return const SizedBox();
  }
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
    )),
  );
}
