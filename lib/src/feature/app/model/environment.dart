import 'package:flutter/foundation.dart';

/// The environment.
enum Environment._(
  /// The environment value.
  final String value,
) {
  /// Development environment.
  dev._('DEV'),

  /// Staging environment.
  staging._('STAGING'),

  /// Production environment.
  prod._('PROD');

  /// Returns the environment from the given [value].
  static Environment from(String? value) => switch (value) {
    'DEV' => Environment.dev,
    'STAGING' => Environment.staging,
    'PROD' => Environment.prod,
    _ => kReleaseMode ? Environment.prod : Environment.dev,
  };
}
