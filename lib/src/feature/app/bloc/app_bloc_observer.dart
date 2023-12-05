import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:wordly/src/core/common/common.dart';

/// [BlocObserver] which logs all bloc state changes, errors and events.
class const AppBlocObserver(
  /// Logger used to log information during bloc transitions.
  final Logger logger,
) extends BlocObserver {
  /// Creates an instance of [AppBlocObserver] with the provided [logger].
  this;

  @override
  void onTransition(Bloc<Object?, Object?> bloc, Transition<Object?, Object?> transition) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${transition.event.runtimeType}')
      ..writeln(
        'Transition: ${transition.currentState.runtimeType} => '
        '${transition.nextState.runtimeType}',
      )
      ..write('New State: ${transition.nextState}');

    logger.info(logMessage.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${event.runtimeType}')
      ..write('Details: ${event?.toString().limit(200)}');

    logger.info(logMessage.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln(error.toString());

    logger.error(logMessage.toString(), error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
