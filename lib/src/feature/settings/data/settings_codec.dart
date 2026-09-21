import 'dart:ui';

import 'package:wordly/src/feature/settings/data/general_settings_codec.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/localization/localization.dart';
import 'package:wordly/src/utils/jsonmap_codec.dart';

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
      general: general ?? GeneralSettings(locale: Localization.deviceLocale),
      dictionary: dictionaryValue ?? Localization.deviceLocale,
      hardMode: input['hardMode'] as bool? ?? false,
    );
  }

  @override
  Map<String, Object?> $encode(Settings input) => {
    'general': generalSettingsCodec.encode(input.general),
    'dictionary': input.dictionary.languageCode,
    'hardMode': input.hardMode,
  };
}
