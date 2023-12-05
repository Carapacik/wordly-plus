import 'package:wordly/src/feature/app/model/environment.dart';

/// Application configuration
class const ApplicationConfig() {
  /// Creates a new [ApplicationConfig] instance.
  this;

  /// The current environment.
  Environment get environment {
    String env = const String.fromEnvironment('ENVIRONMENT').trim();

    if (env.isNotEmpty) {
      return Environment.from(env);
    }

    env = const String.fromEnvironment('FLUTTER_APP_FLAVOR').trim();

    return Environment.from(env);
  }

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN').trim();

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;

  String get mySite => 'https://carapacik.github.io';

  String get email => 'carapacik@gmail.com';

  String get webLink => 'https://carapacik.github.io/wordly_plus/';

  String get androidLink => 'https://play.google.com/store/apps/details?id=com.carapacik.wordly';
}
