// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';
import 'package:ecinema_mobile/utils/error_snackbar.dart';
import 'package:ecinema_mobile/utils/success_snackBar.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/changePassword';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late UserProvider userProvider;
  bool _obscurePass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmNewPass = true;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
  }

  Future<void> _changePassword() async {
    Map<String, dynamic> changePass = Map.from(_formKey.currentState!.value);
    changePass['id'] = Authorization.userId;

    try {
      var answer = await userProvider.changePassword(changePass);
      if (answer == 'Ok') {
        Authorization.password = changePass['NewPassword'];
        showSuccessSnackBar(context, 'Password successfully saved.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (e.toString().contains('Wrong credentials')) {
        showErrorSnackBar(context, 'Wrong credentials.');
      } else {
        showErrorDialog(context, e.toString().substring(11));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: 320,
          child: FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildFormField(
                      name: 'Password',
                      labelText: 'Password',
                      obscurePassword: _obscurePass,
                      validators: [
                        FormBuilderValidators.required(errorText: 'Password is required'),
                      ],
                      icon: Icons.password_outlined,
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _obscurePass = !_obscurePass;
                        });
                      },
                    ),
                    buildFormField(
                      name: 'NewPassword',
                      labelText: 'New password',
                      obscurePassword: _obscureNewPass,
                      validators: [
                        FormBuilderValidators.required(errorText: 'Password is required'),
                        FormBuilderValidators.minLength(7, errorText: 'Password should be at least 7 characters long'),
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
                      ],
                      icon: Icons.password_outlined,
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _obscureNewPass = !_obscureNewPass;
                        });
                      },
                    ),
                    buildFormField(
                      name: 'ConfirmNewPassword',
                      labelText: 'Confirm new password',
                      obscurePassword: _obscureConfirmNewPass,
                      validators: [
                        FormBuilderValidators.required(errorText: 'Confirm new password is required'),
                        (value) {
                          final newPass = _formKey.currentState?.fields['NewPassword']?.value;
                          if (newPass != value) {
                            return "Passwords don't match.";
                          } else {
                            return null;
                          }
                        },
                      ],
                      icon: Icons.password_outlined,
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _obscureConfirmNewPass = !_obscureConfirmNewPass;
                        });
                      },
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.saveAndValidate()) {
                            _changePassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          backgroundColor: darkRedColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Change password"),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildFormField({
    required String name,
    required String labelText,
    required List<FormFieldValidator<String>> validators,
    required IconData icon,
    String? hintText,
    int? errorMaxLines,
    required bool obscurePassword,
    required VoidCallback onTogglePasswordVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: FormBuilderTextField(
        obscureText: obscurePassword,
        cursorColor: Colors.white,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: name,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          hintText: hintText,
          errorMaxLines: errorMaxLines,
          suffixIcon: IconButton(
              color: Colors.white,
              onPressed: () {
                onTogglePasswordVisibility();
              },
              icon:
                  obscurePassword ? const Icon(Icons.visibility_off_outlined) : const Icon(Icons.visibility_outlined)),
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
}
