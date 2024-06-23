import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

const blueColor = Color.fromARGB(255, 16, 24, 53);
const redColor = Color.fromARGB(255, 106, 8, 8);
const darkRedColor = Color.fromARGB(255, 155, 24, 24);
var phoneNumberFormatter = MaskTextInputFormatter(
    mask: '+### ## ### ####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

const stripePublishKey = String.fromEnvironment('stripePublishKey',
    defaultValue:
        'pk_test_51P9X94Ar4z3NmmaxBIbLmvFYSFWtWsT3d622YTgGm8H2tVCrs5EGFa2AUGpHYTA9rstagIRslCF2OqhmUusuQOJh0056qG4M6W');
const stripeSecretKey = String.fromEnvironment('stripeSecretKey',
    defaultValue:
        'sk_test_51P9X94Ar4z3NmmaxOtlZCdd8TT93TfzYxDh4oEme92GZyGZnKg06DZvspsKs84leJDlM8VzVXpaymHyGibV3yoXX00hFCoCBwz');
