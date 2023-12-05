import 'package:logger/logger.dart' show Logger;
import 'package:logger/src/logger.dart' show LogObserver;

export 'src/logger.dart';
export 'src/printing_log_observer.dart';

late Logger logger;

Logger createAppLogger({List<LogObserver> observers = const []}) {
  logger = Logger();

  for (final observer in observers) {
    logger.addObserver(observer);
  }

  return logger;
}
