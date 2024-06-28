// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:ecinema_mobile/utils/success_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  Future<void> _register() async {
    Map<String, dynamic> newUser = Map.from(_formKey.currentState!.value);
    newUser['BirthDate'] = DateFormat('yyyy-MM-dd').format(_formKey.currentState!.value['BirthDate']);
    newUser['IsActive'] = true;
    newUser['IsVerified'] = false;

    try {
      await _userProvider.insert(newUser);

      if (context.mounted) {
        showSuccessSnackBar(context, 'Registration successful.');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const LoginScreen()));
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
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/cinemaPic.jpeg",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Card(
                color: Colors.white.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FormBuilder(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              child: FormBuilderTextField(
                                cursorColor: Colors.white,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'FirstName',
                                decoration: const InputDecoration(
                                    labelText: 'First name', labelStyle: TextStyle(color: Colors.white)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(errorText: 'First name is required')]),
                              ),
                            ),
                            SizedBox(
                              child: FormBuilderTextField(
                                cursorColor: Colors.white,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'LastName',
                                decoration: const InputDecoration(
                                    labelText: 'Last name', labelStyle: TextStyle(color: Colors.white)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(errorText: 'Last name is required')]),
                              ),
                            ),
                            SizedBox(
                              child: FormBuilderTextField(
                                cursorColor: Colors.white,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'Username',
                                decoration: const InputDecoration(
                                    labelText: 'Username', labelStyle: TextStyle(color: Colors.white)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(errorText: 'Username is required')]),
                              ),
                            ),
                            SizedBox(
                              child: FormBuilderTextField(
                                cursorColor: Colors.white,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'Email',
                                decoration: const InputDecoration(
                                    labelText: 'Email',
                                    errorMaxLines: 2,
                                    hintText: 'name@example.com',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: 'Email is required'),
                                  FormBuilderValidators.email(errorText: 'Email is not in the correct format')
                                ]),
                              ),
                            ),
                            SizedBox(
                              child: FormBuilderTextField(
                                inputFormatters: [phoneNumberFormatter],
                                cursorColor: Colors.white,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'PhoneNumber',
                                decoration: const InputDecoration(
                                    labelText: 'Phone number',
                                    errorMaxLines: 2,
                                    hintText: '+387 61 234 5678',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: 'Phone number is required'),
                                  FormBuilderValidators.minLength(15,
                                      errorText: 'Phone number is too short, minimum is 15 digits'),
                                  FormBuilderValidators.maxLength(16,
                                      errorText: 'Phone number is too long, maximum is 16 characters')
                                ]),
                              ),
                            ),
                            SizedBox(
                              child: FormBuilderDateTimePicker(
                                firstDate: DateTime(1950, 1, 1),
                                lastDate: DateTime(2008, 12, 31),
                                initialDate: DateTime(2008, 12, 31),
                                format: DateFormat("yyyy-MM-dd"),
                                inputType: InputType.date,
                                cursorColor: Colors.grey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'BirthDate',
                                decoration: const InputDecoration(
                                    labelText: 'Birth date', labelStyle: TextStyle(color: Colors.white)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(errorText: 'Birth date is required')]),
                              ),
                            ),
                            SizedBox(
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
                                decoration: const InputDecoration(
                                    labelText: 'Gender', labelStyle: TextStyle(color: Colors.white)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(errorText: 'Gender is required')]),
                              ),
                            ),
                            SizedBox(
                              child: FormBuilderTextField(
                                obscureText: _obscurePassword,
                                cursorColor: Colors.white,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                name: 'Password',
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  errorMaxLines: 2,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  suffixIcon: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: _obscurePassword
                                          ? const Icon(Icons.visibility_off_outlined)
                                          : const Icon(Icons.visibility_outlined)),
                                ),
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
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    _register();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(35),
                                  backgroundColor: const Color.fromARGB(255, 16, 24, 53),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text("SIGN UP"),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(builder: (builder) => const LoginScreen()));
                                  },
                                  child: const Text("Login"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
