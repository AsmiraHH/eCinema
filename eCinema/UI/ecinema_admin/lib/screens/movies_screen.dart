// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:ecinema_admin/models/movie.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/utils/util.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int _currentPage = 1;
  final _pageSize = 5;
  late MovieProvider _movieProvider;
  PagedResult<Movie>? moviesResult;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _movieProvider = context.read<MovieProvider>();
    loadMovies({'PageNumber': _currentPage, 'PageSize': _pageSize});

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadMovies({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Title': searchText});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Column(children: [buildSearchField(context), buildDataContainer(context)]),
      title: "Movies",
    );
  }

  void loadMovies(dynamic request) async {
    try {
      var data = await _movieProvider.getPaged(request);
      setState(() {
        moviesResult = data;
        // isLoading = false;
        // clearFilters = true;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
              ));
    }
  }

  Row buildDataContainer(BuildContext context) {
    return Row(children: [
      SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width),
          child: Container(
            margin: const EdgeInsets.only(left: 70, right: 70, bottom: 70, top: 20),
            padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.circular(15)),
            child: DataTable(
              dataRowColor: MaterialStateProperty.all(const Color.fromARGB(42, 241, 241, 241)),
              // columnSpacing: 100,
              columns: [
                DataColumn(label: Text('Naziv')),
                DataColumn(label: Text('Opis')),
                DataColumn(label: Text('Autor')),
                DataColumn(label: Text('Trajanje')),
                DataColumn(label: Text('Jezik')),
                DataColumn(label: Text('Produkcija')),
                DataColumn(label: Text('Slika')),
              ],
              rows: moviesResult?.items
                      .map((Movie movie) => DataRow(
                            cells: [
                              DataCell(Text(movie.title.toString())),
                              DataCell(Text(movie.description.toString())),
                              DataCell(Text(movie.author.toString())),
                              DataCell(Text(movie.duration.toString())),
                              DataCell(Text(movie.language!.name.toString())),
                              DataCell(Text(movie.production!.name.toString())),
                              DataCell(
                                movie.photo != ""
                                    ? SizedBox(width: 40, height: 40, child: fromBase64String(movie.photo!))
                                    : const SizedBox(child: Icon(Icons.photo, size: 40, color: Colors.black)),
                              )
                            ],
                          ))
                      .toList() ??
                  [],
            ),
          ),
        ),
      ),
    ]);
  }

  Row buildSearchField(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(70, 16, 16, 0),
          height: 35,
          width: 400,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10.0),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.blueAccent,
                ),
                hintText: 'Movie title',
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 3, color: Colors.blueAccent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.blueAccent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.blueAccent))),
          ),
        )
      ],
    );
  }
}
