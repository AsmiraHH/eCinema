// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/user.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/change_password_screen.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProvider userProvider;
  User? user;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _editClicked = false;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    loadUser();
  }

  void loadUser() async {
    try {
      _isLoading = true;
      var data = await userProvider.getById(Authorization.userId);
      setState(() {
        user = data;
        _isLoading = false;
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

  Future<void> _editUser() async {
    Map<String, dynamic> editUser = Map.from(_formKey.currentState!.value);
    editUser['id'] = user?.id;
    editUser['Role'] = user?.role;
    editUser['Gender'] = user?.gender;
    editUser['IsActive'] = user?.isActive;
    editUser['IsVerified'] = user?.isVerified;
    editUser['photoBase64'] = "";

    editUser['BirthDate'] = DateFormat('yyyy-MM-dd').format(_formKey.currentState!.value['BirthDate']);

    try {
      await userProvider.update(editUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: redColor,
            content: Center(
              child: Text('Changes successfully saved.',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )),
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }

    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          // title: Center(
          //   child: Text(
          //     "Profile",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _buildLogoutDialog(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /// -- IMAGE
                Stack(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: user != null && user!.profilePhoto != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(150), child: fromBase64String(user!.profilePhoto!))
                            : null),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: darkRedColor),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${user!.firstName!} ${user!.lastName!}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  user!.email!,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                /// -- BUTTON
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _editClicked = !_editClicked;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: darkRedColor, side: BorderSide.none, shape: const StadiumBorder()),
                      child: const Text(
                        'Edit profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ChangePasswordScreen.routeName,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: darkRedColor, side: BorderSide.none, shape: const StadiumBorder()),
                      child: const Text(
                        'Change password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),

                /// -- PROFILE INFO
                SizedBox(
                  width: 320,
                  child: FormBuilder(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildFormField(
                              name: 'FirstName',
                              labelText: 'First name',
                              validators: [
                                FormBuilderValidators.required(errorText: 'First name is required'),
                              ],
                              icon: Icons.person_outline,
                              initialValue: user!.firstName!,
                            ),
                            buildFormField(
                              name: 'LastName',
                              labelText: 'Last name',
                              validators: [
                                FormBuilderValidators.required(errorText: 'Last name is required'),
                              ],
                              icon: Icons.person_outline,
                              initialValue: user!.lastName!,
                            ),
                            buildFormField(
                              name: 'Username',
                              labelText: 'Username',
                              validators: [
                                FormBuilderValidators.required(errorText: 'Username is required'),
                              ],
                              icon: Icons.person_pin_circle_outlined,
                              initialValue: user!.username!,
                            ),
                            buildFormField(
                              name: 'Email',
                              labelText: 'Email',
                              validators: [
                                FormBuilderValidators.required(errorText: 'Email is required'),
                                FormBuilderValidators.email(errorText: 'Email is not in the correct format'),
                              ],
                              icon: Icons.email,
                              hintText: 'name@example.com',
                              errorMaxLines: 2,
                              initialValue: user!.email!,
                            ),
                            buildFormField(
                              name: 'PhoneNumber',
                              labelText: 'Phone number',
                              validators: [
                                FormBuilderValidators.required(errorText: 'Email is required'),
                                FormBuilderValidators.minLength(15,
                                    errorText: 'Phone number is too short, minimum is 15 digits'),
                                FormBuilderValidators.maxLength(16,
                                    errorText: 'Phone number is too long, maximum is 16 characters')
                              ],
                              icon: Icons.phone,
                              hintText: '+387 61 234 5678',
                              errorMaxLines: 2,
                              initialValue: user!.phoneNumber!,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 50,
                              child: FormBuilderDateTimePicker(
                                firstDate: DateTime(1950, 1, 1),
                                lastDate: DateTime(2008, 12, 31),
                                initialDate: DateTime(2008, 12, 31),
                                format: DateFormat("yyyy-MM-dd"),
                                inputType: InputType.date,
                                cursorColor: Colors.white,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'BirthDate',
                                initialValue: DateTime.parse(user!.birthDate.toString()),
                                enabled: _editClicked,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  labelText: 'Birth date',
                                  labelStyle: const TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(color: Colors.red),
                                  ),
                                  prefixIcon: const Icon(Icons.date_range_outlined, color: darkRedColor),
                                ),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(errorText: 'Birth date is required')]),
                              ),
                            ),
                            _editClicked
                                ? SizedBox(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.saveAndValidate()) {
                                          _editUser();
                                          setState(() {
                                            _editClicked = false;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(35),
                                        backgroundColor: darkRedColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text("Save changes"),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget buildFormField({
    required String name,
    required String labelText,
    required List<FormFieldValidator<String>> validators,
    required IconData icon,
    required String initialValue,
    String? hintText,
    int? errorMaxLines,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: FormBuilderTextField(
        cursorColor: Colors.white,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: name,
        enabled: _editClicked,
        initialValue: initialValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          hintText: hintText,
          errorMaxLines: errorMaxLines,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          prefixIcon: Icon(icon, color: darkRedColor),
        ),
        validator: FormBuilderValidators.compose(validators),
      ),
    );
  }

  void _buildLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                userProvider.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: darkRedColor, side: BorderSide.none, shape: const StadiumBorder()),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
