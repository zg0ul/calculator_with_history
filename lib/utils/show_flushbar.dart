import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFloatingFlushbar({
  @required BuildContext? context,
  @required String? message,
}) {
  // ignore: unused_local_variable
  Flushbar(
    message: message,
    backgroundColor: const Color.fromARGB(200, 0, 0, 0),
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(20),
    borderRadius: BorderRadius.circular(50),
    messageColor: Colors.white,
    flushbarStyle: FlushbarStyle.FLOATING,
    maxWidth: 130,
  ).show(context!);
}
