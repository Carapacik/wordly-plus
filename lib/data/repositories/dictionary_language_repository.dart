import 'dart:convert';

import 'package:wordle/data/repositories/save_reactive_repository.dart';
import 'package:wordle/data/shared_preferences_data.dart';

class DictionaryLanguageRepository extends SaveReactiveRepository<String> {
  factory DictionaryLanguageRepository.getInstance() =>
      _instance ??= DictionaryLanguageRepository._internal(
        SharedPreferenceData.getInstance(),
      );

  DictionaryLanguageRepository._internal(this.spData);

  static DictionaryLanguageRepository? _instance;

  final SharedPreferenceData spData;

  @override
  String convertFromString(String rawItem) => json.decode(rawItem) as String;

  @override
  String convertToString(String item) => json.encode(item);

  @override
  Future<String?> getRawData() => spData.getDictionaryLanguage();

  @override
  Future<bool> setRawData(String item) => spData.saveDictionaryLanguage(item);
}
