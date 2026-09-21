import 'dart:async' show runZonedGuarded;

import 'package:bloc/bloc.dart' show Bloc;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter/widgets.dart' show FlutterError, WidgetsBinding, WidgetsFlutterBinding, runApp;
import 'package:wordly/src/feature/app/logic/composition_root.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/app/widget/initialization_failed_app.dart';
import 'package:wordly/src/feature/app/widget/root_context.dart';
import 'package:wordly/src/logging/app_bloc_observer.dart';
import 'package:wordly/src/logging/app_logger.dart';

Future<void> startup() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      AppLogger.error('Flutter error', details.exception, details.stack ?? StackTrace.current);
    };
    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      AppLogger.error('Platform error', error, stack);
      return true;
    };
    Bloc.observer = const AppBlocObserver();

    Future<void> composeAndRun() async {
      try {
        final DependenciesContainer dependencies = await composeDependencies();

        runApp(RootContext(dependencies: dependencies));
      } on Object catch (e, stackTrace) {
        AppLogger.error('Initialization failed', e, stackTrace);
        runApp(InitializationFailedApp(error: e, stackTrace: stackTrace, onRetryInitialization: composeAndRun));
      }
    }

    await composeAndRun();
  }, (error, stack) => AppLogger.error('Uncaught error', error, stack));
}
