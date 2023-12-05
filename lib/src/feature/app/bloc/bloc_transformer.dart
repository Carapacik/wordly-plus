import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

/// A function that maps an event of type [Event] to a stream of events.
abstract base class BlocTransformer<Event>() {
  /// Transforms the given [stream] of events.
  Stream<Event> transform(Stream<Event> stream, EventMapper<Event> mapper);
}

/// Sequentially maps events to a stream of events.
final class SequentialBlocTransformer<Event>() extends BlocTransformer<Event> {
  @override
  Stream<Event> transform(Stream<Event> stream, EventMapper<Event> mapper) => stream.asyncExpand(mapper);
}

/// For search and similar.
final class DenounceRestartableBlocTransformer<Event>([Duration? duration]) extends BlocTransformer<Event> {
  final Duration _duration = duration ?? const Duration(milliseconds: 700);

  @override
  Stream<Event> transform(Stream<Event> stream, EventMapper<Event> mapper) =>
      stream.debounceTime(_duration).switchMap(mapper);
}

/// For pagination.
final class ThrottleDroppableBlocTransformer<Event>([Duration? duration]) extends BlocTransformer<Event> {
  final Duration _duration = duration ?? const Duration(milliseconds: 700);

  @override
  Stream<Event> transform(Stream<Event> stream, EventMapper<Event> mapper) =>
      stream.throttleTime(_duration).switchMap(mapper);
}
