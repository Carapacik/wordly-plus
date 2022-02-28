import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';

Future<void> showSnackBar(
  final BuildContext context, {
  required final String message,
}) async {
  final width = MediaQuery.of(context).size.width;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTypography.m18,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      duration: const Duration(milliseconds: 600),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: width > 500 ? (width - 500) / 2 + 72 : 12,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
