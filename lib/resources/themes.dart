import 'package:flutter/material.dart';

enum AppTheme { lightTheme, darkTheme }

extension AppThemeExt on AppTheme {
  ThemeData get theme {
    switch (this) {
      case AppTheme.lightTheme:
        return ThemeData.light().copyWith(
          primaryColorDark: const Color(0xDC121213),
          primaryColorLight: const Color(0xFFFFFFFF),
          primaryColor: const Color(0xFF000000),
          colorScheme: const ColorScheme.light(secondary: Color(0xDCDEE6F2)),
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          backgroundColor: const Color(0xFFFFFFFF),
          cardColor: const Color(0xFFDCE1E9),
          shadowColor: const Color(0xFF787C7E),
          useMaterial3: true,
        );
      case AppTheme.darkTheme:
        return ThemeData.dark().copyWith(
          primaryColorDark: const Color(0xFFFFFFFF),
          primaryColorLight: const Color(0xDC121213),
          primaryColor: const Color(0xFFFFFFFF),
          colorScheme: const ColorScheme.dark(secondary: Color(0xFF9EA2B7)),
          scaffoldBackgroundColor: const Color(0xFF1E1F30),
          cardColor: const Color(0xFF6D6F82),
          backgroundColor: const Color(0xDC121213),
          shadowColor: const Color(0xFF494B61),
          useMaterial3: true,
        );
    }
  }
}
