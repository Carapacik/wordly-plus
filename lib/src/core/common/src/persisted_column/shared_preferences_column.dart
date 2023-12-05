import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/core/common/src/persisted_column/persisted_column.dart';

/// [SharedPreferencesColumn] describes a single persisted entry in [SharedPreferences].
abstract base class const SharedPreferencesColumn<T extends Object>({
  /// The instance of [SharedPreferences] used to read and write values.
  required final SharedPreferencesAsync sharedPreferences,

  /// The key used to store the value in the cache.
  required final String key,
}) extends PersistedColumn<T> {
  @override
  Future<void> remove() async {
    await sharedPreferences.remove(key);
  }
}

/// A [int] implementation of [SharedPreferencesColumn].
final class const SharedPreferencesColumnInteger({required super.sharedPreferences, required super.key})
    extends SharedPreferencesColumn<int> {
  @override
  Future<int?> read() => sharedPreferences.getInt(key);

  @override
  Future<void> set(int value) async {
    await sharedPreferences.setInt(key, value);
  }
}

/// A [String] implementation of [SharedPreferencesColumn].
final class const SharedPreferencesColumnString({required super.sharedPreferences, required super.key})
    extends SharedPreferencesColumn<String> {
  /// {@macro string_preferences_entry}
  this;

  @override
  Future<String?> read() => sharedPreferences.getString(key);

  @override
  Future<void> set(String value) async {
    await sharedPreferences.setString(key, value);
  }
}

/// A [bool] implementation of [SharedPreferencesColumn].
final class const SharedPreferencesColumnBoolean({required super.sharedPreferences, required super.key})
    extends SharedPreferencesColumn<bool> {
  @override
  Future<bool?> read() => sharedPreferences.getBool(key);

  @override
  Future<void> set(bool value) async {
    await sharedPreferences.setBool(key, value);
  }
}

/// A [double] implementation of [SharedPreferencesColumn].
final class const SharedPreferencesColumnDouble({required super.sharedPreferences, required super.key})
    extends SharedPreferencesColumn<double> {
  @override
  Future<double?> read() => sharedPreferences.getDouble(key);

  @override
  Future<void> set(double value) async {
    await sharedPreferences.setDouble(key, value);
  }
}

/// A [List<String>] implementation of [SharedPreferencesColumn].
final class const SharedPreferencesColumnStringList({required super.sharedPreferences, required super.key})
    extends SharedPreferencesColumn<List<String>> {
  @override
  Future<List<String>?> read() => sharedPreferences.getStringList(key);

  @override
  Future<void> set(List<String> value) async {
    await sharedPreferences.setStringList(key, value);
  }
}

final class const SharedPreferencesColumnJson({required super.sharedPreferences, required super.key})
    extends SharedPreferencesColumn<Map<String, Object?>> {
  @override
  Future<Map<String, Object?>?> read() async {
    final String? jsonString = await sharedPreferences.getString(key);
    if (jsonString == null) {
      return null;
    }

    final dynamic decoded = jsonDecode(jsonString);

    if (decoded is Map<String, Object?>) {
      return decoded;
    }

    throw const FormatException('Stored value is not a JSON object');
  }

  @override
  Future<void> set(Map<String, Object?> value) async {
    final String jsonString = jsonEncode(value);

    await sharedPreferences.setString(key, jsonString);
  }
}
