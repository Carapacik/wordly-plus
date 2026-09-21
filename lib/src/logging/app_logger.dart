import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract final class AppLogger() {
  static void info(String message, {String name = 'App'}) {
    if (kDebugMode) {
      developer.log(message, name: 'WordlyPlus.$name', level: 800);
    }
  }

  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(message, name: 'WordlyPlus.App', level: 900, error: error, stackTrace: stackTrace);
    }
  }

  static void error(String message, Object error, StackTrace stackTrace, {String name = 'App'}) {
    if (kDebugMode) {
      developer.log(message, name: 'WordlyPlus.$name', level: 1000, error: error, stackTrace: stackTrace);
    }
  }
}
