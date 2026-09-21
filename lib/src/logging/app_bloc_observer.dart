import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/logging/app_logger.dart';

class const AppBlocObserver() extends BlocObserver {
  @override
  void onTransition(Bloc<Object?, Object?> bloc, Transition<Object?, Object?> transition) {
    AppLogger.info(
      '${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}',
      name: '${bloc.runtimeType}',
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error('Bloc error', error, stackTrace, name: '${bloc.runtimeType}');
    super.onError(bloc, error, stackTrace);
  }
}
