// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/models/user.dart';
import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:ecinema_admin/utils/util.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int _currentPage = 1;
  final _pageSize = 12;
  late UserProvider _userProvider;
  PagedResult<User>? usersResult;
  User? selectedUser;
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  String? _base64Image;
  int? selectedGender;
  bool? isActive;
  bool? isVerified;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    loadUsers({'PageNumber': _currentPage, 'PageSize': _pageSize});

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadUsers({
        'PageNumber': _currentPage,
        'PageSize': _pageSize,
        'Name': searchText,
        'Gender': selectedGender,
        'isActive': isActive,
        'isVerified': isVerified,
      });
    });
  }

  Future<void> loadUsers(dynamic request) async {
    try {
      var data = await _userProvider.getPaged(request);
      setState(() {
        usersResult = data;
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

  Future<void> _saveUser(bool isEdit) async {
    Map<String, dynamic> newUser = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newUser['id'] = selectedUser?.id;
      newUser['Role'] = selectedUser?.role;
    }
    newUser['photoBase64'] = _base64Image;
    newUser['BirthDate'] = DateFormat('yyyy-MM-dd').format(_formKey.currentState!.value['BirthDate']);

    try {
      if (!isEdit) {
        await _userProvider.insert(newUser);
      } else {
        await _userProvider.update(newUser);
      }

      Navigator.of(context).pop();
      loadUsers({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteUser() async {
    try {
      var response = await _userProvider.delete(selectedUser!.id!);

      if (response) {
        selectedUser = null;
        loadUsers({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
      title: "Users",
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
                DataColumn(label: Text('Username')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone number')),
                DataColumn(label: Text('Birthdate')),
                DataColumn(label: Text('Gender')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Verified')),
                DataColumn(label: Text('Profile photo')),
              ],
              rows: usersResult?.items.map((User user) {
                    return DataRow(
                      selected: selectedUser == user,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedUser = user;
                      }),
                      cells: [
                        DataCell(Text("${user.firstName} ${user.lastName}")),
                        DataCell(Text(user.username.toString())),
                        DataCell(Text(user.email.toString())),
                        DataCell(Text(user.phoneNumber.toString())),
                        DataCell(Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(user.birthDate.toString())))),
                        DataCell(Text(user.gender == 0 ? 'Male' : 'Female')),
                        DataCell(Container(
                            margin: const EdgeInsets.only(left: 9),
                            child: user.isActive == true
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
                        DataCell(Container(
                            margin: const EdgeInsets.only(left: 11),
                            child: user.isVerified == true
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
                          user.profilePhoto != ""
                              ? SizedBox(width: 40, height: 40, child: fromBase64String(user.profilePhoto!))
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
                  loadUsers({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Name': _searchController.text,
                    'Gender': selectedGender,
                    'isActive': isActive,
                    'isVerified': isVerified,
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
                  loadUsers({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Name': _searchController.text,
                    'Gender': selectedGender,
                    'isActive': isActive,
                    'isVerified': isVerified
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
                  child: Text('Verified'),
                ),
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Unverified'),
                ),
              ],
              value: isVerified == null
                  ? null
                  : isVerified == true
                      ? 1
                      : 0,
              onChanged: (int? newValue) {
                setState(() {
                  isVerified = newValue == null ? null : newValue != 0;
                  loadUsers({
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Name': _searchController.text,
                    'Gender': selectedGender,
                    'isActive': isActive,
                    'isVerified': isVerified
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
                      title: const Text('Add user'),
                      content: SingleChildScrollView(child: buildAddUserModal(isEdit: false, userEdit: null)),
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
                              _saveUser(false);
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
            onPressed: selectedUser == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one user."),
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
                              title: const Text('Edit user'),
                              content: buildAddUserModal(isEdit: true, userEdit: selectedUser),
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
                                      _saveUser(true);
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
            onPressed: selectedUser == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one user."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete user"),
                              content: const Text("Are you sure you want to delete the selected user?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteUser();
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

  Widget buildAddUserModal({bool isEdit = false, User? userEdit}) {
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
                              isEdit && userEdit?.profilePhoto != ""
                                  ? SizedBox(
                                      width: 300,
                                      height: 320,
                                      child: fromBase64String(userEdit!.profilePhoto!),
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
                              initialValue: userEdit != null ? userEdit.firstName : '',
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
                              initialValue: userEdit != null ? userEdit.lastName : '',
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
                              name: 'Username',
                              initialValue: userEdit != null ? userEdit.username : '',
                              decoration: const InputDecoration(labelText: 'Username'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Username is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Email',
                              initialValue: userEdit != null ? userEdit.email.toString() : '',
                              decoration:
                                  const InputDecoration(labelText: 'Email', errorMaxLines: 2, hintText: 'name@example.com'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Email is required'),
                                FormBuilderValidators.email(errorText: 'Email is not in the correct format')
                              ]),
                            ),
                          ),
                          !isEdit
                              ? SizedBox(
                                  width: 250,
                                  child: FormBuilderTextField(
                                    obscureText: true,
                                    cursorColor: Colors.grey,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    name: 'Password',
                                    initialValue: userEdit != null ? userEdit.password.toString() : '',
                                    decoration: const InputDecoration(labelText: 'Password', errorMaxLines: 2),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'Password is required'),
                                      FormBuilderValidators.minLength(7,
                                          errorText: 'Password should be at least 7 characters long'),
                                      FormBuilderValidators.match(
                                        '[A-Z]+',
                                        errorText: 'Password should contain at least one uppercase letter',
                                      ),
                                      FormBuilderValidators.match(
                                        '[a-z]+',
                                        errorText: 'Password should contain at least one lowercase letter',
                                      ),
                                      FormBuilderValidators.match(
                                        '[0-9]+',
                                        errorText: 'Password should contain at least one digit',
                                      ),
                                    ]),
                                  ),
                                )
                              : const SizedBox.shrink(),
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
                              initialValue: userEdit != null ? userEdit.phoneNumber.toString() : '',
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
                              initialValue: userEdit != null ? DateTime.parse(userEdit.birthDate.toString()) : null,
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
                              initialValue: userEdit?.gender,
                              decoration: const InputDecoration(labelText: 'Gender'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Gender is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: FormBuilderCheckbox(
                                    title: const Text('Active'),
                                    name: 'IsActive',
                                    initialValue: userEdit?.isActive,
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: FormBuilderCheckbox(
                                    title: const Text('Verified'),
                                    name: 'IsVerified',
                                    initialValue: userEdit?.isVerified,
                                  ),
                                ),
                              ],
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
                    loadUsers({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Name': _searchController.text,
                      'Gender': selectedGender,
                      'isActive': isActive,
                      'isVerified': isVerified,
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
            onPressed: usersResult?.hasNextPage ?? false
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    loadUsers({
                      'PageNumber': _currentPage,
                      'PageSize': _pageSize,
                      'Name': _searchController.text,
                      'Gender': selectedGender,
                      'isActive': isActive,
                      'isVerified': isVerified,
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
