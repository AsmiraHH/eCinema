// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/hall.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/models/show.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/hall_provider.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/show_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShowsScreen extends StatefulWidget {
  const ShowsScreen({super.key});

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  int _currentPage = 1;
  final _pageSize = 12;
  late ShowProvider _showProvider;
  late MovieProvider _movieProvider;
  late CinemaProvider _cinemaProvider;
  late HallProvider _hallProvider;
  PagedResult<Show>? showsResult;
  List<Movie>? moviesResult;
  List<Hall>? hallsResult;
  List<Cinema>? cinemasResult;
  List<Hall>? filteredHallsResult;
  Show? selectedShow;
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  int? selectedHall;
  int? selectedCinema;
  String? selectedFormat;
  List<String>? formats = ['TwoD', 'Extreme2D', 'ThreeD', 'Extreme3D', 'FourD'];

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _hallProvider = context.read<HallProvider>();
    _movieProvider = context.read<MovieProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    loadShows({'PageNumber': _currentPage, 'PageSize': _pageSize});
    loadMovies();
    loadHalls();
    loadCinemas();

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadShows({
        'PageNumber': _currentPage,
        'PageSize': _pageSize,
        'Movie': searchText,
        'Cinema': selectedCinema,
        'Hall': selectedHall,
        'Format': selectedFormat,
      });
    });
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
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
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
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  Future<void> loadMovies() async {
    try {
      var data = await _movieProvider.getAll();
      setState(() {
        moviesResult = data;
      });
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

  Future<void> loadHalls() async {
    try {
      var data = await _hallProvider.getAll();

      setState(() {
        hallsResult = data;
        filteredHallsResult = hallsResult;
      });
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

  Future<void> _saveShow(bool isEdit) async {
    Map<String, dynamic> newShow = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newShow['id'] = selectedShow?.id;
    }
    newShow['DateTime'] = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_formKey.currentState!.value['DateTime']);

    try {
      if (!isEdit) {
        await _showProvider.insert(newShow);
      } else {
        await _showProvider.update(newShow);
      }

      Navigator.of(context).pop();
      loadShows({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteShow() async {
    try {
      var response = await _showProvider.delete(selectedShow!.id!);

      if (response) {
        selectedShow = null;
        loadShows({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
    return MasterScreen(
      title: "Shows",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildFilterDropDowns(context), buildSearchField(context), buildDataContainer(context), buildPagination()]),
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
            padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(10)),
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Movie')),
                DataColumn(label: Text('Projection date')),
                DataColumn(label: Text('Start time')),
                DataColumn(label: Text('Format')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Hall')),
                DataColumn(label: Text('Cinema')),
              ],
              rows: showsResult?.items.map((Show show) {
                    return DataRow(
                      selected: selectedShow == show,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedShow = show;
                      }),
                      cells: [
                        DataCell(Text(show.movie!.title.toString())),
                        DataCell(Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(show.dateTime.toString())))),
                        DataCell(Text(DateFormat.Hm().format(DateTime.parse(show.dateTime.toString())))),
                        DataCell(Text(show.format.toString())),
                        DataCell(Text('${show.price.toString()} KM')),
                        DataCell(Text(show.hall!.name.toString())),
                        DataCell(Text(show.hall!.cinema!.name.toString())),
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
                  child: Text('All Cinemas'),
                ),
                ...cinemasResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name!,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedCinema,
              onChanged: (int? newValue) {
                setState(() {
                  selectedCinema = newValue;
                  loadShows({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
                    'Hall': selectedHall,
                    'Format': selectedFormat,
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
                  child: Text('All Halls'),
                ),
                ...hallsResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name!,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedHall,
              onChanged: (int? newValue) {
                setState(() {
                  selectedHall = newValue;
                  loadShows({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
                    'Hall': selectedHall,
                    'Format': selectedFormat,
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
            child: DropdownButton<String>(
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Formats'),
                ),
                ...formats
                        ?.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedFormat,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFormat = newValue;
                  loadShows({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
                    'Hall': selectedHall,
                    'Format': selectedFormat,
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
            decoration: const InputDecoration(
                filled: true,
                fillColor: blueColor,
                contentPadding: EdgeInsets.only(top: 10.0, left: 10.0),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search ...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
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
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: blueColor,
                      title: const Text('Add show'),
                      content: SingleChildScrollView(child: buildAddShowModal(isEdit: false, showEdit: null)),
                      actions: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: const Text('Close'),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.saveAndValidate()) {
                              _saveShow(false);
                            }
                          },
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: const Text('Save'),
                        )
                      ],
                    );
                  });
            },
            child: const Icon(Icons.add)),
        const SizedBox(width: 5),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: selectedShow == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one show."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              backgroundColor: blueColor,
                              title: const Text('Edit show'),
                              content: buildAddShowModal(isEdit: true, showEdit: selectedShow),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Close'),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.saveAndValidate()) {
                                      _saveShow(true);
                                    }
                                  },
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Save'),
                                )
                              ],
                            );
                          });
                        });
                  },
            child: const Icon(Icons.edit)),
        const SizedBox(width: 5),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: selectedShow == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one show."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete show"),
                              content: const Text("Are you sure you want to delete the selected show?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteShow();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete"))
                              ],
                            ));
                  },
            child: const Icon(Icons.delete_forever_rounded))
      ]),
    );
  }

  Widget buildAddShowModal({bool isEdit = false, Show? showEdit}) {
    return SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    runAlignment: WrapAlignment.spaceEvenly,
                    spacing: 40,
                    runSpacing: 10,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 340,
                            child: FormBuilderDropdown<int>(
                              items: moviesResult
                                      ?.map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.title!,
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'MovieId',
                              initialValue: showEdit?.movie?.id,
                              decoration: const InputDecoration(labelText: 'Movie'),
                              validator:
                                  FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Movie is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderDateTimePicker(
                              firstDate: DateTime.now().add(const Duration(days: 1)),
                              initialDate: DateTime.now().add(const Duration(days: 1)),
                              format: DateFormat("dd/MM/yyyy HH:mm"),
                              inputType: InputType.both,
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'DateTime',
                              initialValue: showEdit != null ? DateTime.parse(showEdit.dateTime.toString()) : null,
                              decoration: const InputDecoration(labelText: 'Projection date - time'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Projection date is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Price',
                              initialValue: showEdit != null ? showEdit.price.toString() : '',
                              decoration: const InputDecoration(labelText: 'Price'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Price is required'),
                                FormBuilderValidators.integer(errorText: 'Price has to be a number')
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderDropdown<String>(
                              items: formats
                                      ?.map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList() ??
                                  [],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Format',
                              initialValue: showEdit?.format,
                              decoration: const InputDecoration(labelText: 'Format'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Format is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderDropdown<int>(
                              items: hallsResult
                                      ?.map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              '${e.cinema?.name ?? ''} - ${e.name!}',
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'HallId',
                              initialValue: showEdit?.hall?.id,
                              decoration: const InputDecoration(labelText: 'Hall'),
                              validator:
                                  FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Hall is required')]),
                            ),
                          )
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
      margin: const EdgeInsets.only(right: 80, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    loadShows({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Movie': _searchController.text,
                      'Cinema': selectedCinema,
                      'Hall': selectedHall,
                      'Format': selectedFormat,
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
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: showsResult?.hasNextPage ?? false
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    loadShows({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Movie': _searchController.text,
                      'Cinema': selectedCinema,
                      'Hall': selectedHall,
                      'Format': selectedFormat,
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
