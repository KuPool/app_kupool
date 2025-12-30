import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void show(
    String msg, {
    Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForIosWeb = 2,
    ToastGravity gravity = ToastGravity.CENTER,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,      
      timeInSecForIosWeb: timeInSecForIosWeb,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
