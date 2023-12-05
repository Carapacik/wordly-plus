import 'dart:async' show runZonedGuarded;

import 'package:bloc/bloc.dart' show Bloc;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter/widgets.dart' show FlutterError, WidgetsBinding, WidgetsFlutterBinding, runApp;
import 'package:logger/logger.dart' as l show LogLevel, PrintingLogObserver, createAppLogger, logger;
import 'package:wordly/src/feature/app/bloc/app_bloc_observer.dart';
import 'package:wordly/src/feature/app/bloc/bloc_transformer.dart';
import 'package:wordly/src/feature/app/logic/composition_root.dart';
import 'package:wordly/src/feature/app/model/application_config.dart';
import 'package:wordly/src/feature/app/widget/initialization_failed_app.dart';
import 'package:wordly/src/feature/app/widget/root_context.dart';

/// Initializes dependencies and runs app
Future<void> startup() async {
  const config = ApplicationConfig();

  l.createAppLogger(observers: [if (!kReleaseMode) const l.PrintingLogObserver(logLevel: l.LogLevel.trace)]);

  await runZonedGuarded(() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Configure global error interception
    FlutterError.onError = l.logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError = l.logger.logPlatformDispatcherError;

    // Setup bloc observer and transformer
    Bloc.observer = AppBlocObserver(l.logger);
    Bloc.transformer = SequentialBlocTransformer<Object?>().transform;

    Future<void> composeAndRun() async {
      try {
        final CompositionResult compositionResult = await composeDependencies(config: config);

        runApp(RootContext(compositionResult: compositionResult));
      } on Object catch (e, stackTrace) {
        l.logger.error('Initialization failed', error: e, stackTrace: stackTrace);
        runApp(InitializationFailedApp(error: e, stackTrace: stackTrace, onRetryInitialization: composeAndRun));
      }
    }

    // Launch the application
    await composeAndRun();
  }, l.logger.logZoneError);
}
