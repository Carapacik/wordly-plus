import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final class const SharedPreferencesColumnJson({
  required final SharedPreferencesAsync sharedPreferences,
  required final String key,
}) {
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

  Future<void> set(Map<String, Object?> value) async {
    final String jsonString = jsonEncode(value);

    await sharedPreferences.setString(key, jsonString);
  }
}
