import 'dart:ui';

import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/settings/src/data/mappers/general_settings_codec.dart';

class const SettingsCodec() extends JsonMapCodec<Settings> {
  @override
  Settings $decode(Map<String, Object?> input) {
    final generalMap = input['general'] as Map<String, Object?>?;
    final dictionary = input['dictionary'] as String?;

    GeneralSettings? general;
    if (generalMap != null) {
      general = generalSettingsCodec.decode(generalMap);
    }
    final Locale? dictionaryValue = dictionary == null ? null : Locale.fromSubtags(languageCode: dictionary);

    return Settings(
      general: general ?? GeneralSettings(locale: Localization.computeDefaultLocale()),
      dictionary: dictionaryValue ?? Localization.computeDefaultLocale(withDictionary: true),
    );
  }

  @override
  Map<String, Object?> $encode(Settings input) => {
    'general': generalSettingsCodec.encode(input.general),
    'dictionary': input.dictionary.languageCode,
  };
}
