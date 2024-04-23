// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/providers/actor_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  final _currentPage = 1;
  final _pageSize = 10;
  late ActorProvider _actorProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  PagedResult<Actor>? actorsResult;
  final TextEditingController _searchController = TextEditingController();
  Actor? selectedActor;
  int? selectedGender;
  @override
  void initState() {
    super.initState();
    _actorProvider = context.read<ActorProvider>();
    loadActors({'PageNumber': _currentPage, 'PageSize': _pageSize});

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadActors({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': searchText, 'Gender': selectedGender});
    });
  }

  Future<void> loadActors(dynamic request) async {
    try {
      var data = await _actorProvider.getPaged(request);
      setState(() {
        actorsResult = data;
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

  Future<void> _saveActor(bool isEdit) async {
    Map<String, dynamic> newActor = Map.from(_formKey.currentState!.value);
    newActor['BirthDate'] = DateFormat('yyyy-MM-dd').format(_formKey.currentState!.value['BirthDate']);

    if (isEdit) {
      newActor['id'] = selectedActor?.id;
    }

    try {
      if (!isEdit) {
        await _actorProvider.insert(newActor);
      } else {
        await _actorProvider.update(newActor);
      }

      Navigator.of(context).pop();
      loadActors({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteActor() async {
    try {
      var response = await _actorProvider.delete(selectedActor!.id!);

      if (response) {
        selectedActor = null;
        loadActors({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
      title: "Actors",
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
                DataColumn(label: Text('Gender')),
                DataColumn(label: Text('Birth date')),
                DataColumn(label: Text('Email')),
              ],
              rows: actorsResult?.items.map((Actor actor) {
                    return DataRow(
                      selected: selectedActor == actor,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedActor = actor;
                      }),
                      cells: [
                        DataCell(Text('${actor.firstName} ${actor.lastName}')),
                        DataCell(Text(actor.gender == 0 ? 'Male' : 'Female')),
                        DataCell(Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(actor.birthDate.toString())))),
                        DataCell(Text(actor.email.toString())),
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

  Container buildFilterDropDowns(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.fromLTRB(40, 40, 10, 0),
        height: 35,
        width: 400,
        child: DropdownButton(
          items: const [
            DropdownMenuItem<int>(
              value: null,
              child: Text('All'),
            ),
            DropdownMenuItem<int>(
              value: 0,
              child: Text('Male'),
            ),
            DropdownMenuItem<int>(
              value: 1,
              child: Text('Female'),
            ),
          ],
          value: selectedGender,
          onChanged: (int? newValue) {
            setState(() {
              selectedGender = newValue;
              loadActors({
                'PageNumber': _currentPage,
                'PageSize': _pageSize,
                'Name': _searchController.text,
                'Gender': selectedGender,
              });
            });
          },
          isExpanded: true,
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          underline: Container(),
          style: const TextStyle(color: Colors.white),
        ));
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
                      title: const Text('Add actor'),
                      content: SingleChildScrollView(child: buildAddActorModal(isEdit: false, actorEdit: null)),
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
                              _saveActor(false);
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
            onPressed: selectedActor == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one actor."),
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
                              title: const Text('Edit actor'),
                              content: buildAddActorModal(isEdit: true, actorEdit: selectedActor),
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
                                      _saveActor(true);
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
            onPressed: selectedActor == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one actor."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete actor"),
                              content: const Text("Are you sure you want to delete the selected actor?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteActor();
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

  Widget buildAddActorModal({bool isEdit = false, Actor? actorEdit}) {
    return SizedBox(
        height: 310,
        width: 700,
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
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'FirstName',
                              initialValue: actorEdit != null ? actorEdit.firstName : '',
                              decoration: const InputDecoration(labelText: 'First name'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'First name is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'LastName',
                              initialValue: actorEdit != null ? actorEdit.lastName : '',
                              decoration: const InputDecoration(labelText: 'Last name'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Last name is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Email',
                              initialValue: actorEdit != null ? actorEdit.email : '',
                              decoration: const InputDecoration(labelText: 'Email'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Email is required'),
                                FormBuilderValidators.email(errorText: 'Email is not in the correct format')
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 250,
                            child: FormBuilderDateTimePicker(
                              format: DateFormat("yyyy-MM-dd"),
                              inputType: InputType.date,
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'BirthDate',
                              initialValue: actorEdit != null ? DateTime.parse(actorEdit.birthDate.toString()) : null,
                              decoration: const InputDecoration(labelText: 'Birth date'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Birth date is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderDropdown<int>(
                              items: const [
                                DropdownMenuItem<int>(
                                  value: 0,
                                  child: Text('Male'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text('Female'),
                                ),
                              ],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Gender',
                              initialValue: actorEdit?.gender,
                              decoration: const InputDecoration(labelText: 'Gender'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Gender is required')]),
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
