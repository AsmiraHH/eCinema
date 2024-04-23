// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:ecinema_admin/helpers/constants.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  int _currentPage = 1;
  final _pageSize = 12;

  late MovieProvider _movieProvider;
  late GenreProvider _genreProvider;
  late LanguageProvider _languageProvider;
  late ProductionProvider _productionProvider;

  PagedResult<Movie>? moviesResult;
  List<Genre>? genresResult;
  List<Language>? languagesResult;
  List<Production>? productionsResult;

  int? selectedLanguage;
  int? selectedProduction;
  int? selectedGenre;

  final TextEditingController _searchController = TextEditingController();
  final MultiSelectController<int> _genreController = MultiSelectController<int>();

  Movie? selectedMovie;

  String? _base64Image;

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
      loadMovies({
        'PageNumber': _currentPage,
        'PageSize': _pageSize,
        'Title': searchText,
        'Language': selectedLanguage,
        'Production': selectedProduction,
        'Genre': selectedGenre,
      });
    });
  }

  Future<void> loadMovies(dynamic request) async {
    try {
      var data = await _movieProvider.getPaged(request);
      setState(() {
        moviesResult = data;
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
      var data = await _genreProvider.getAll();
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
      var data = await _languageProvider.getAll();
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
      var data = await _productionProvider.getAll();
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

  Future<void> _saveMovie(bool isEdit) async {
    Map<String, dynamic> newMovie = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newMovie['id'] = selectedMovie?.id;
    }

    newMovie['photoBase64'] = _base64Image;
    newMovie['GenreIDs'] = _genreController.selectedOptions.map((e) => e.value).toList();

    try {
      if (!isEdit) {
        await _movieProvider.insert(newMovie);
      } else {
        await _movieProvider.update(newMovie);
      }

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

  Future<void> _deleteMovie() async {
    try {
      var response = await _movieProvider.delete(selectedMovie!.id!);

      if (response) {
        selectedMovie = null;
        loadMovies({'PageNumber': _currentPage, 'PageSize': _pageSize});
      }
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

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildFilterDropDowns(context), buildSearchField(context), buildDataContainer(context), buildPagination()]),
      title: "Movies",
    );
  }

  Expanded buildDataContainer(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width),
          child: Container(
            margin: const EdgeInsets.only(left: 80, right: 80, bottom: 70, top: 20),
            padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(10)),
            child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text('Title')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Author')),
                DataColumn(label: Text('Duration')),
                DataColumn(label: Text('Genre')),
                DataColumn(label: Text('Language')),
                DataColumn(label: Text('Production')),
                DataColumn(label: Text('Photo')),
              ],
              rows: moviesResult?.items.map((Movie movie) {
                    return DataRow(
                      selected: selectedMovie == movie,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedMovie = movie;
                      }),
                      cells: [
                        DataCell(Text(movie.title.toString())),
                        DataCell(Text(movie.description.toString())),
                        DataCell(Text(movie.author.toString())),
                        DataCell(Text(movie.duration.toString())),
                        DataCell(Text(movie.genres!.map((genre) => genre.genre!.name).join(', '))),
                        DataCell(Text(movie.language?.name != null ? movie.language!.name.toString() : '')),
                        DataCell(Text(movie.production?.name != null ? movie.production!.name.toString() : '')),
                        DataCell(
                          movie.photo != ""
                              ? SizedBox(width: 40, height: 40, child: fromBase64String(movie.photo!))
                              : const SizedBox(child: Icon(Icons.photo, size: 40, color: Colors.white)),
                        )
                      ],
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ),
      ),
    );
  }

  Row buildFilterDropDowns(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
            height: 35,
            width: MediaQuery.sizeOf(context).width / 4.5,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All'),
                ),
                ...languagesResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name!,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedLanguage,
              onChanged: (int? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                  loadMovies({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Language': selectedLanguage,
                    'Production': selectedProduction,
                    'Genre': selectedGenre,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(30, 40, 10, 0),
            height: 35,
            width: MediaQuery.sizeOf(context).width / 4.5,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All'),
                ),
                ...productionsResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name!,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedProduction,
              onChanged: (int? newValue) {
                setState(() {
                  selectedProduction = newValue;
                  loadMovies({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Language': selectedLanguage,
                    'Production': selectedProduction,
                    'Genre': selectedGenre,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(30, 40, 10, 0),
            height: 35,
            width: MediaQuery.sizeOf(context).width / 4.5,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All'),
                ),
                ...genresResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name!,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedGenre,
              onChanged: (int? newValue) {
                setState(() {
                  selectedGenre = newValue;
                  loadMovies({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Language': selectedLanguage,
                    'Production': selectedProduction,
                    'Genre': selectedGenre,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  Row buildSearchField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(80, 10, 10, 0),
          height: 35,
          width: MediaQuery.sizeOf(context).width / 4.5,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                filled: true,
                fillColor: blueColor,
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
      margin: const EdgeInsets.fromLTRB(30, 10, 20, 0),
      child: Row(children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: blueColor,
                      title: const Text('Add movie'),
                      content: SingleChildScrollView(child: buildAddMovieModal(isEdit: false, movieEdit: null)),
                      actions: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.saveAndValidate()) {
                              _saveMovie(false);
                            }
                          },
                          child: Text('Save'),
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        )
                      ],
                    );
                  });
            },
            child: const Icon(Icons.add)),
        SizedBox(width: 5),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: selectedMovie == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Warning"),
                              content: Text("You have to select at least one movie."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              backgroundColor: blueColor,
                              title: const Text('Edit movie'),
                              content: buildAddMovieModal(isEdit: true, movieEdit: selectedMovie),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.saveAndValidate()) {
                                      _saveMovie(true);
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
            child: const Icon(Icons.edit)),
        SizedBox(width: 5),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: selectedMovie == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Warning"),
                              content: Text("You have to select at least one movie."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Delete movie"),
                              content: Text("Are you sure you want to delete the selected movie?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteMovie();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Delete"))
                              ],
                            ));
                  },
            child: const Icon(Icons.delete_forever_rounded))
      ]),
    );
  }

  Widget buildAddMovieModal({bool isEdit = false, Movie? movieEdit}) {
    if (!isEdit) {
      _genreController.clearAllSelection();
      _base64Image = "";
    } else {
      _base64Image = movieEdit?.photo!;
    }
    return SizedBox(
        height: 450,
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
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(
                          width: 250,
                          child: FormBuilderImagePicker(
                            name: 'photoBase64',
                            availableImageSources: const [ImageSourceOption.gallery],
                            maxImages: 1,
                            previewAutoSizeWidth: true,
                            fit: BoxFit.cover,
                            previewHeight: 320,
                            previewWidth: 100,
                            initialValue: [
                              isEdit && movieEdit?.photo != ""
                                  ? SizedBox(
                                      width: 300,
                                      height: 320,
                                      child: fromBase64String(movieEdit!.photo!),
                                    )
                                  : null
                            ],
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty && value.first is! SizedBox && value.first != null) {
                                File file = File(value.first.path);
                                _base64Image = base64Encode(file.readAsBytesSync());
                              }
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty || value.first == null) {
                                return 'Image is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ]),
                      Column(
                        children: [
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Title',
                              initialValue: movieEdit != null ? movieEdit.title : '',
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
                              initialValue: movieEdit != null ? movieEdit.author : '',
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
                              name: 'ReleaseYear',
                              initialValue: movieEdit != null ? movieEdit.releaseYear.toString() : '',
                              decoration: InputDecoration(labelText: 'Release year'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Release year is required'),
                                FormBuilderValidators.numeric(errorText: 'Release year has to be a number'),
                                FormBuilderValidators.minLength(4, errorText: 'Release year has to have at least four digits')
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Duration',
                              initialValue: movieEdit != null ? movieEdit.duration.toString() : '',
                              decoration: InputDecoration(labelText: 'Duration'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Duration is required'),
                                FormBuilderValidators.numeric(errorText: 'Duration has to be a number (minutes)'),
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              maxLines: 2,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Description',
                              initialValue: movieEdit != null ? movieEdit.description.toString() : '',
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
                              items: languagesResult
                                      ?.map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name!,
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'LanguageId',
                              initialValue: movieEdit?.language?.id,
                              decoration: InputDecoration(labelText: 'Language'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Language is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderDropdown<int>(
                              items: productionsResult
                                      ?.map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name!,
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'ProductionId',
                              initialValue: movieEdit?.production?.id,
                              decoration: InputDecoration(labelText: 'Production'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Production is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderField(
                              name: 'GenreIDs',
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Genre',
                                    labelStyle: TextStyle(fontSize: 20.0),
                                    errorText: field.errorText,
                                  ),
                                  child: MultiSelectDropDown<int>(
                                    optionsBackgroundColor: Colors.black,
                                    selectedOptionBackgroundColor: Colors.black,
                                    fieldBackgroundColor: Colors.black,
                                    singleSelectItemStyle: TextStyle(color: Colors.black, backgroundColor: Colors.black),
                                    controller: _genreController,
                                    inputDecoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.transparent),
                                    ),
                                    hint: "",
                                    padding: EdgeInsets.all(0),
                                    onOptionSelected: (List<ValueItem<int>> selectedOptions) {
                                      _genreController.setSelectedOptions(selectedOptions);
                                    },
                                    options: genresResult!.map((e) {
                                      return ValueItem<int>(
                                        value: e.id,
                                        label: e.name!,
                                      );
                                    }).toList(),
                                    selectedOptions: movieEdit?.genres != null
                                        ? movieEdit!.genres!.map((movieGenre) {
                                            return ValueItem<int>(
                                              value: movieGenre.genre!.id!,
                                              label: movieGenre.genre!.name!,
                                            );
                                          }).toList()
                                        : [],
                                    selectionType: SelectionType.multi,
                                    chipConfig: ChipConfig(backgroundColor: blueColor.withOpacity(1)),
                                  ),
                                );
                              },
                              validator: (value) {
                                if (_genreController.selectedOptions.isEmpty) {
                                  return 'Genre is required';
                                } else {
                                  return null;
                                }
                              },
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

  Widget buildPagination() {
    return Container(
      margin: EdgeInsets.only(right: 80, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    loadMovies({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Title': _searchController.text,
                      'Language': selectedLanguage,
                      'Production': selectedProduction,
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
                backgroundColor: blueColor,
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: moviesResult?.hasNextPage ?? false
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    loadMovies({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Title': _searchController.text,
                      'Language': selectedLanguage,
                      'Production': selectedProduction,
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
      ),
    );
  }
}
