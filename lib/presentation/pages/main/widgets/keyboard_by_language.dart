import 'package:flutter/material.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/presentation/pages/main/widgets/keyboard_en.dart';
import 'package:wordly/presentation/pages/main/widgets/keyboard_ru.dart';

class KeyboardByLanguage extends StatelessWidget {
  const KeyboardByLanguage({this.language = DictionaryLanguages.en, super.key});

  final DictionaryLanguages language;

  @override
  Widget build(BuildContext context) {
    switch (language) {
      case DictionaryLanguages.ru:
        return const KeyboardRu();
      case DictionaryLanguages.en:
        return const KeyboardEn();
    }
  }
}
