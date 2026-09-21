import 'dart:async';
import 'dart:collection';

class MutexLock() {
  final _queue = DoubleLinkedQueue<Completer<void>>();

  Future<void> lock() {
    final Future<void> previous = _queue.lastOrNull?.future ?? Future<void>.value();
    _queue.add(Completer<void>.sync());

    return previous;
  }

  void unlock() {
    if (_queue.isEmpty) {
      assert(false, 'Mutex unlock called when no tasks are waiting.');
      return;
    }

    final Completer<void> completer = _queue.removeFirst();

    if (completer.isCompleted) {
      assert(false, 'Mutex unlock called when the completer is already completed.');
      return;
    }

    completer.complete();
  }

  Future<T> runLocked<T>(FutureOr<T> Function() fn) async {
    await lock();

    try {
      return await fn();
    } finally {
      unlock();
    }
  }
}
