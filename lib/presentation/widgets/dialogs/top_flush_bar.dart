import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> showTopFlushBar(
  final BuildContext context, {
  required final String message,
}) async {
  Flushbar(
    message: message,
    maxWidth: 400,
    duration: const Duration(milliseconds: 1200),
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Theme.of(context).primaryColorDark,
    messageColor: Theme.of(context).primaryColorLight,
    margin: const EdgeInsets.fromLTRB(16, 32, 16, 0),
    padding: const EdgeInsets.all(24),
    borderRadius: BorderRadius.circular(12),
  ).show(context);
}
