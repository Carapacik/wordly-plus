import 'package:flutter/material.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
}

final Map<AppTheme, ThemeData> themes = {
  AppTheme.lightTheme: ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline6: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    primaryColorDark: const Color(0xDC121213),
    primaryColorLight: const Color(0xFFFFFFFF),
    primaryColor: const Color(0xFF000000),
    colorScheme: const ColorScheme.light(secondary: Color(0xDC121213)),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    backgroundColor: const Color(0xFFFFFFFF),
    cardColor: const Color(0xffd3d6da),
    hintColor: const Color(0xFF6AAA64),
    shadowColor: const Color(0xFF787C7E),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  AppTheme.darkTheme: ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    primaryColorDark: const Color(0xFFFFFFFF),
    primaryColorLight: const Color(0xDC121213),
    primaryColor: const Color(0xFFFFFFFF),
    colorScheme: const ColorScheme.dark(secondary: Color(0xFF23B4B6)),
    scaffoldBackgroundColor: const Color(0xDC121213),
    cardColor: const Color(0xff818384),
    backgroundColor: const Color(0xDC121213),
    hintColor: const Color(0xff538d4e),
    shadowColor: const Color(0xff565758),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  )
};
