// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/hall.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/hall_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class HallsScreen extends StatefulWidget {
  const HallsScreen({super.key});

  @override
  State<HallsScreen> createState() => _HallsScreenState();
}

class _HallsScreenState extends State<HallsScreen> {
  final _currentPage = 1;
  final _pageSize = 10;
  final _formKey = GlobalKey<FormBuilderState>();
  late HallProvider _hallProvider;
  late CinemaProvider _cinemaProvider;
  PagedResult<Hall>? hallsResult;
  List<Cinema>? cinemasResult;
  Hall? selectedHall;
  final TextEditingController _searchController = TextEditingController();
  int? selectedCinema;

  @override
  void initState() {
    super.initState();
    _hallProvider = context.read<HallProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    loadHalls({'PageNumber': _currentPage, 'PageSize': _pageSize});
    loadCinemas();

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadHalls({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': searchText, 'Cinema': selectedCinema});
    });
  }

  Future<void> loadHalls(dynamic request) async {
    try {
      var data = await _hallProvider.getPaged(request);
      setState(() {
        hallsResult = data;
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

  Future<void> _saveHall(bool isEdit) async {
    Map<String, dynamic> newHall = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newHall['id'] = selectedHall?.id;
    }

    try {
      if (!isEdit) {
        await _hallProvider.insert(newHall);
      } else {
        await _hallProvider.update(newHall);
      }

      Navigator.of(context).pop();
      loadHalls({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteHall() async {
    try {
      var response = await _hallProvider.delete(selectedHall!.id!);

      if (response) {
        selectedHall = null;
        loadHalls({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
      title: "Halls",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [buildSearchField(context), buildDataContainer(context)]),
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
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Number of seats')),
                DataColumn(label: Text('Cinema')),
              ],
              rows: hallsResult?.items.map((Hall hall) {
                    return DataRow(
                      selected: selectedHall == hall,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedHall = hall;
                      }),
                      cells: [
                        DataCell(Text(hall.name.toString())),
                        DataCell(Text(hall.numberOfSeats.toString())),
                        DataCell(Text(hall.cinema!.name.toString())),
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

  Container buildFilterDropDowns(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.fromLTRB(40, 40, 10, 0),
        height: 35,
        width: 400,
        child: DropdownButton<int>(
          items: [
            const DropdownMenuItem<int>(
              value: null,
              child: Text('All'),
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
              loadHalls({
                'PageNumber': _currentPage,
                'PageSize': _pageSize,
                'Name': _searchController.text,
                'Cinema': selectedCinema,
              });
            });
          },
          isExpanded: true,
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          underline: Container(),
          style: const TextStyle(color: Colors.white),
        ));
  }

  Row buildSearchField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
          height: 35,
          width: 400,
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
        buildFilterDropDowns(context),
        buildButtons(context)
      ],
    );
  }

  Container buildButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 40, 20, 0),
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
                      title: const Text('Add hall'),
                      content: SingleChildScrollView(child: buildAddHallModal(isEdit: false, hallEdit: null)),
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
                              _saveHall(false);
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
            onPressed: selectedHall == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one hall."),
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
                              title: const Text('Edit hall'),
                              content: buildAddHallModal(isEdit: true, hallEdit: selectedHall),
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
                                      _saveHall(true);
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
            onPressed: selectedHall == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one hall."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete hall"),
                              content: const Text("Are you sure you want to delete the selected hall?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteHall();
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

  Widget buildAddHallModal({bool isEdit = false, Hall? hallEdit}) {
    return SizedBox(
        height: 310,
        width: 600,
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
                      Column(
                        children: [
                          SizedBox(
                            width: 330,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Name',
                              initialValue: hallEdit != null ? hallEdit.name : '',
                              decoration: const InputDecoration(labelText: 'Name'),
                              validator:
                                  FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Name is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 330,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'NumberOfSeats',
                              initialValue: hallEdit != null ? hallEdit.numberOfSeats.toString() : '',
                              decoration: const InputDecoration(labelText: 'Number of seats'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Number of seats is required'),
                                FormBuilderValidators.numeric(errorText: 'Number of seats has to be a number')
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 330,
                            child: FormBuilderDropdown<int>(
                              items: cinemasResult
                                      ?.map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name!,
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'CinemaId',
                              initialValue: hallEdit?.cinema?.id,
                              decoration: const InputDecoration(labelText: 'Cinema'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Cinema is required')]),
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
}
