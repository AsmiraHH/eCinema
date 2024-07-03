// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/employee.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/employee_provider.dart';
import 'package:ecinema_admin/utils/util.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  int _currentPage = 1;
  final _pageSize = 12;
  late EmployeeProvider _employeeProvider;
  late CinemaProvider _cinemaProvider;
  PagedResult<Employee>? employeesResult;
  List<Cinema>? cinemasResult;
  Employee? selectedEmployee;
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  String? _base64Image;
  int? selectedGender;
  int? selectedCinema;
  bool? isActive;

  @override
  void initState() {
    super.initState();
    _employeeProvider = context.read<EmployeeProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    loadEmployees({'PageNumber': _currentPage, 'PageSize': _pageSize});
    loadCinemas();

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadEmployees({
        'PageNumber': _currentPage,
        'PageSize': _pageSize,
        'Name': searchText,
        'isActive': isActive,
        'Gender': selectedGender,
        'selectedCinema': selectedCinema
      });
    });
  }

  Future<void> loadEmployees(dynamic request) async {
    try {
      var data = await _employeeProvider.getPaged(request);
      setState(() {
        employeesResult = data;
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

  Future<void> _saveEmployee(bool isEdit) async {
    Map<String, dynamic> newEmployee = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newEmployee['id'] = selectedEmployee?.id;
    }
    newEmployee['photoBase64'] = _base64Image;
    newEmployee['BirthDate'] = DateFormat('yyyy-MM-dd').format(_formKey.currentState!.value['BirthDate']);

    try {
      if (!isEdit) {
        await _employeeProvider.insert(newEmployee);
      } else {
        await _employeeProvider.update(newEmployee);
      }

      Navigator.of(context).pop();
      loadEmployees({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteEmployee() async {
    try {
      var response = await _employeeProvider.delete(selectedEmployee!.id!);

      if (response) {
        selectedEmployee = null;
        loadEmployees({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
      title: "Employees",
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
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone number')),
                DataColumn(label: Text('Birthdate')),
                DataColumn(label: Text('Gender')),
                DataColumn(label: Text('Cinema')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Profile photo')),
              ],
              rows: employeesResult?.items.map((Employee employee) {
                    return DataRow(
                      selected: selectedEmployee == employee,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedEmployee = employee;
                      }),
                      cells: [
                        DataCell(Text('${employee.firstName} ${employee.lastName}')),
                        DataCell(Text(employee.email.toString())),
                        DataCell(Text(employee.phoneNumber.toString())),
                        DataCell(Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(employee.birthDate.toString())))),
                        DataCell(Text(employee.gender == 0 ? 'Male' : 'Female')),
                        DataCell(Text(employee.cinema!.name.toString())),
                        DataCell(Container(
                            margin: const EdgeInsets.only(left: 9),
                            child: employee.isActive == true
                                ? const Icon(
                                    Icons.check_box_outlined,
                                    color: Colors.green,
                                    size: 25,
                                  )
                                : const Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                    size: 25,
                                  ))),
                        DataCell(
                          employee.profilePhoto != ""
                              ? SizedBox(width: 40, height: 40, child: fromBase64String(employee.profilePhoto!))
                              : const SizedBox(child: Icon(Icons.photo, size: 40, color: Colors.white)),
                        ),
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
                  loadEmployees({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Name': _searchController.text,
                    'Gender': selectedGender,
                    'Cinema': selectedCinema,
                    'isActive': isActive,
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
                  loadEmployees({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Name': _searchController.text,
                    'Gender': selectedGender,
                    'Cinema': selectedCinema,
                    'isActive': isActive,
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
            child: DropdownButton(
              items: const [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text('All'),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Active'),
                ),
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Unactive'),
                ),
              ],
              value: isActive == null
                  ? null
                  : isActive == true
                      ? 1
                      : 0,
              onChanged: (int? newValue) {
                setState(() {
                  isActive = newValue == null ? null : newValue != 0;
                  loadEmployees({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Name': _searchController.text,
                    'Gender': selectedGender,
                    'Cinema': selectedCinema,
                    'isActive': isActive
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
                      title: const Text('Add employee'),
                      content: SingleChildScrollView(child: buildAddEmployeeModal(isEdit: false, employeeEdit: null)),
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
                              _saveEmployee(false);
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
            onPressed: selectedEmployee == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one employee."),
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
                              title: const Text('Edit employee'),
                              content: buildAddEmployeeModal(isEdit: true, employeeEdit: selectedEmployee),
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
                                      _saveEmployee(true);
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
            onPressed: selectedEmployee == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one employee."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete employee"),
                              content: const Text("Are you sure you want to delete the selected employee?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteEmployee();
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

  Widget buildAddEmployeeModal({bool isEdit = false, Employee? employeeEdit}) {
    return SizedBox(
        width: 900,
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
                              isEdit && employeeEdit?.profilePhoto != ""
                                  ? SizedBox(
                                      width: 300,
                                      height: 320,
                                      child: fromBase64String(employeeEdit!.profilePhoto!),
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
                              name: 'FirstName',
                              initialValue: employeeEdit != null ? employeeEdit.firstName : '',
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
                              initialValue: employeeEdit != null ? employeeEdit.lastName : '',
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
                              initialValue: employeeEdit != null ? employeeEdit.email.toString() : '',
                              decoration:
                                  const InputDecoration(labelText: 'Email', errorMaxLines: 2, hintText: 'name@example.com'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Email is required'),
                                FormBuilderValidators.email(errorText: 'Email is not in the correct format')
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
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
                              initialValue: employeeEdit?.cinema?.id,
                              decoration: const InputDecoration(labelText: 'Cinema'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Cinema is required')]),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              inputFormatters: [phoneNumberFormatter],
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'PhoneNumber',
                              initialValue: employeeEdit?.phoneNumber?.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Phone number', errorMaxLines: 2, hintText: '+387 61 234 5678'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Phone number is required'),
                                FormBuilderValidators.minLength(15, errorText: 'Phone number is too short, minimum is 15 digits'),
                                FormBuilderValidators.maxLength(16,
                                    errorText: 'Phone number is too long, maximum is 16 characters')
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderDateTimePicker(
                              firstDate: DateTime(1950, 1, 1),
                              lastDate: DateTime(2008, 12, 31),
                              initialDate: DateTime(2008, 12, 31),
                              format: DateFormat("yyyy-MM-dd"),
                              inputType: InputType.date,
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'BirthDate',
                              initialValue: employeeEdit != null ? DateTime.parse(employeeEdit.birthDate.toString()) : null,
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
                              initialValue: employeeEdit?.gender,
                              decoration: const InputDecoration(labelText: 'Gender'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Gender is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderCheckbox(
                              title: const Text('Active'),
                              name: 'IsActive',
                              initialValue: employeeEdit?.isActive,
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
                    loadEmployees({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Name': _searchController.text,
                      'isActive': isActive,
                      'Gender': selectedGender,
                      'selectedCinema': selectedCinema
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
            onPressed: employeesResult?.hasNextPage ?? false
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    loadEmployees({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Name': _searchController.text,
                      'isActive': isActive,
                      'Gender': selectedGender,
                      'selectedCinema': selectedCinema
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
