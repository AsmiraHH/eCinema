import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

const blueColor = Color.fromARGB(255, 16, 24, 53);
const redColor = Color.fromARGB(255, 106, 8, 8);

var phoneNumberFormatter =
    MaskTextInputFormatter(mask: '+### ## ### ####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
