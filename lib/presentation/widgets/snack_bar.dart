import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';

void showFloatingSnackBar(
  final BuildContext context, {
  required final String message,
  required final EdgeInsetsGeometry margin,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: context.theme.bl.copyWith(
          color: context.dynamicColor(
            light: AppColors.light,
            dark: AppColors.dark,
          ),
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: context.dynamicColor(
        light: AppColors.dark,
        dark: AppColors.light,
      ),
      duration: const Duration(milliseconds: 700),
      behavior: SnackBarBehavior.floating,
      margin: margin,
      dismissDirection: DismissDirection.up,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
