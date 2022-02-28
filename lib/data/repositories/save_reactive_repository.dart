import 'package:flutter/foundation.dart';

abstract class SaveReactiveRepository<T> {
  @protected
  Future<String?> getRawData();

  @protected
  Future<bool> setRawData(final String item);

  @protected
  T convertFromString(final String rawItem);

  @protected
  String convertToString(final T item);

  Future<T?> getItem() async {
    final rawItem = await getRawData();
    if (rawItem == null) {
      return null;
    }
    return convertFromString(rawItem);
  }

  Future<bool> setItem(final T item) async {
    final rawItem = convertToString(item);
    return setRawData(rawItem);
  }
}
