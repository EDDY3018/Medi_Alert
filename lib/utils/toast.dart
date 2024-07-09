import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastContainer({
  @required String? text,
  Toast toastLength = Toast.LENGTH_LONG,
  required Color backgroundColor,
}) {
  Fluttertoast.showToast(
      msg: text!,
      toastLength: toastLength,
      // gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
