import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/data/models.dart';

abstract class ISaveSettingsRepository {
  bool get isSecondLaunch;

  Future<void> saveDark({required bool value});

  Future<bool> getDark();

  Future<void> saveHighContrast({required bool value});

  Future<bool> getHighContrast();

  Future<void> saveDictionary(DictionaryEnum value);

  Future<DictionaryEnum> getDictionary();

  Future<void> saveLocale(LocaleEnum value);

  Future<LocaleEnum> getLocale();

  Future<void> init();
}

class SaveSettingsRepository implements ISaveSettingsRepository {
  static const _secondLaunchKey = 'second_launch_key';
  static const _isDarkKey = 'is_dark_key';
  static const _isHighContrastKey = 'is_high_contrast_key';
  static const _dictionaryKey = 'dictionary_key';
  static const _localeKey = 'locale_key';
  late bool _isSecondLaunch;

  @override
  bool get isSecondLaunch => _isSecondLaunch;

  @override
  Future<void> saveDark({required bool value}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_isDarkKey, value);
  }

  @override
  Future<bool> getDark() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_isDarkKey) ?? false;
  }

  @override
  Future<void> saveHighContrast({required bool value}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_isHighContrastKey, value);
  }

  @override
  Future<bool> getHighContrast() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_isHighContrastKey) ?? false;
  }

  @override
  Future<void> saveDictionary(DictionaryEnum value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_dictionaryKey, value.index);
  }

  @override
  Future<DictionaryEnum> getDictionary() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_dictionaryKey).toDictionary;
  }

  @override
  Future<void> saveLocale(LocaleEnum value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_localeKey, value.index);
  }

  @override
  Future<LocaleEnum> getLocale() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_localeKey).toLocale;
  }

  @override
  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    final isSecondLaunch = sp.getBool(_secondLaunchKey) ?? false;
    await sp.setBool(_secondLaunchKey, true);
    _isSecondLaunch = isSecondLaunch;
  }
}
