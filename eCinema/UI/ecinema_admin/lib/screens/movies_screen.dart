// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'dart:io';
import 'package:ecinema_admin/models/genre.dart';
import 'package:ecinema_admin/models/language.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/models/production.dart';
import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:ecinema_admin/providers/language_provider.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:ecinema_admin/utils/util.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic>? filters = {};
  int _currentPage = 1;
  final _pageSize = 5;

  late MovieProvider _movieProvider;
  late GenreProvider _genreProvider;
  late LanguageProvider _languageProvider;
  late ProductionProvider _productionProvider;

  PagedResult<Movie>? moviesResult;
  PagedResult<Genre>? genresResult;
  PagedResult<Language>? languagesResult;
  PagedResult<Production>? productionsResult;

  final TextEditingController _searchController = TextEditingController();

  int? selectedGenre;
  int? selectedLanguage;
  int? selectedProduction;

  File? _image;
  String? _base64Image;
  final _imageNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _movieProvider = context.read<MovieProvider>();
    _genreProvider = context.read<GenreProvider>();
    _languageProvider = context.read<LanguageProvider>();
    _productionProvider = context.read<ProductionProvider>();
    loadMovies({'PageNumber': _currentPage, 'PageSize': _pageSize});
    loadGenres();
    loadLanguages();
    loadProductions();

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

  Future<void> loadMovies(dynamic request) async {
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

  void loadGenres() async {
    try {
      var data = await _genreProvider.getPaged(filters);
      setState(() {
        genresResult = data;
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

  void loadLanguages() async {
    try {
      var data = await _languageProvider.getPaged(filters);
      setState(() {
        languagesResult = data;
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

  void loadProductions() async {
    try {
      var data = await _productionProvider.getPaged(filters);
      setState(() {
        productionsResult = data;
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
            margin: const EdgeInsets.only(left: 80, right: 80, bottom: 70, top: 20),
            padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(/*color: Color.fromARGB(255, 16, 24, 53),*/ borderRadius: BorderRadius.circular(10)),
            child: DataTable(
              // dataRowColor: MaterialStateProperty.all(const Color.fromARGB(42, 241, 241, 241)),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(80, 40, 16, 0),
          height: 35,
          width: 400,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                // filled: true,
                // fillColor: Color.fromARGB(150, 16, 24, 53),
                contentPadding: const EdgeInsets.only(top: 10.0, left: 10.0),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search ...',
                hintStyle: TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(width: 3, color: Colors.white)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.white))),
          ),
        ),
        buildButtons(context)
      ],
    );
  }

  Container buildButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 40, 20, 0),
      child: Row(children: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Add movie'),
                        content: SingleChildScrollView(child: buildAddMovieModal()),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              _imageNotifier.value = false;
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> newMovie = Map.from(_formKey.currentState!.value);
                                newMovie['photoBase64'] = _base64Image;
                                try {
                                  await _movieProvider.insert(newMovie);
                                  Navigator.of(context).pop();
                                  loadMovies({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
                            },
                            child: Text('Save'),
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          )
                        ],
                      );
                    });
                  });
            },
            child: const Icon(Icons.add))
      ]),
    );
  }

  Widget buildAddMovieModal({bool isEdit = false, Movie? movieEdit}) {
    return SizedBox(
        height: 500,
        width: 900,
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Wrap(
                    runAlignment: WrapAlignment.spaceEvenly,
                    spacing: 40,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                          width: 250,
                          height: 400,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            ValueListenableBuilder<bool>(
                              valueListenable: _imageNotifier,
                              builder: (context, isImageSelected, _) {
                                return isImageSelected
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            image: FileImage(_image!),
                                          ),
                                        ),
                                      )
                                    : Container();
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              padding: const EdgeInsets.all(15),
                              onPressed: () async => await _selectImage(),
                              // color: Color.fromARGB(255, 16, 24, 53),
                              // textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Text('Select Image'),
                            ),
                          ])),
                      Column(
                        children: [
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Title',
                              decoration: InputDecoration(labelText: 'Title'),
                              validator:
                                  FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Title is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Author',
                              decoration: InputDecoration(labelText: 'Author'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Author is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Release year',
                              decoration: InputDecoration(labelText: 'Release year'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Release year is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Duration',
                              decoration: InputDecoration(labelText: 'Duration'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Duration is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              maxLines: 2,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Description',
                              decoration: InputDecoration(labelText: 'Description'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Description is required')]),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 250,
                            child: FormBuilderDropdown<int>(
                              items: genresResult?.items
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name!,
                                              // style: TextStyle(color: Colors.black), // Text color for dropdown menu items
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              onChanged: (int? value) {
                                setState(() {
                                  selectedGenre = value;
                                });
                              },
                              initialValue: selectedGenre,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'GenreId',
                              decoration: InputDecoration(labelText: 'Genre'),
                              validator:
                                  FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Genre is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderDropdown<int>(
                              items: languagesResult?.items
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name!,
                                              // style: TextStyle(color: Colors.black), // Text color for dropdown menu items
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              onChanged: (int? value) {
                                setState(() {
                                  selectedLanguage = value;
                                });
                              },
                              initialValue: selectedLanguage,
                              // style: TextStyle(color: Colors.white),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'LanguageId',
                              decoration: InputDecoration(labelText: 'Language'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Language is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderDropdown<int>(
                              items: productionsResult?.items
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name!,
                                              // style: TextStyle(color: Colors.black), // Text color for dropdown menu items
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              onChanged: (int? value) {
                                setState(() {
                                  selectedProduction = value;
                                });
                              },
                              initialValue: selectedProduction,
                              // style: TextStyle(color: Colors.white),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'ProductionId',
                              decoration: InputDecoration(labelText: 'Production'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Production is required')]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

  Future<void> _selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _base64Image = base64Encode(_image!.readAsBytesSync());
        _imageNotifier.value = true;
      });
    }
  }
}
