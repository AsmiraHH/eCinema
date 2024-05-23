// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/user.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerDialog extends StatefulWidget {
  final User user;
  final Function(String base64Image) onImageSaved;
  const ImagePickerDialog({super.key, required this.user, required this.onImageSaved});

  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _base64Image = '';
  bool _isImageSelected = false;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
  }

  Future<void> _updateProfileImage() async {
    if (_formKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> newImage = Map.from(_formKey.currentState!.value);

      newImage['id'] = widget.user.id;
      newImage['photoBase64'] = _base64Image;

      try {
        var data = await userProvider.updateProfileImage(newImage);
        Authorization.user = data;
        widget.onImageSaved(_base64Image);
        Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      content: FormBuilder(
        key: _formKey,
        child: FormBuilderImagePicker(
          name: 'photoBase64',
          availableImageSources: const [ImageSourceOption.gallery],
          maxImages: 1,
          previewAutoSizeWidth: true,
          fit: BoxFit.cover,
          previewWidth: 250,
          previewHeight: 300,
          initialValue: [
            widget.user.profilePhoto != ""
                ? SizedBox(
                    width: 250,
                    height: 300,
                    child: fromBase64String(widget.user.profilePhoto!),
                  )
                : null
          ],
          onChanged: (value) {
            setState(() {
              _isImageSelected = value != null && value.isNotEmpty && value.first != null;
            });
          },
          onSaved: (value) {
            // if (value != null && value.isNotEmpty && value.first is! SizedBox && value.first != null) {
            File file = File(value!.first.path);
            _base64Image = base64Encode(file.readAsBytesSync());
            // }
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _isImageSelected
              ? () {
                  _updateProfileImage();
                }
              : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: darkRedColor, side: BorderSide.none, shape: const StadiumBorder()),
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
