import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordly/resources/colors.dart';

final _base = ThemeData.dark(useMaterial3: true);

final darkTheme = _base.copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.dark,
  textTheme: GoogleFonts.ubuntuTextTheme(_base.textTheme).copyWith(
    titleLarge: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.light,
    ),
    titleMedium: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.light,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.light,
    ),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.light,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 48,
        ),
      ),
      elevation: MaterialStateProperty.all(0),
      foregroundColor: MaterialStateProperty.all(AppColors.dark),
      backgroundColor: MaterialStateProperty.all(AppColors.light),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.greyLight,
    selectionColor: AppColors.greyLight,
    selectionHandleColor: AppColors.greyLight,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.dark,
    foregroundColor: AppColors.light,
  ),
);
