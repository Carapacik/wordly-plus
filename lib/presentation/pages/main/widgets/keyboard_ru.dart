import 'package:flutter/material.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/keyboard_keys.dart';
import 'package:wordly/presentation/pages/main/widgets/keyboard_key.dart';

class KeyboardRu extends StatelessWidget {
  const KeyboardRu({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              KeyboardKey(
                keyboardKey: KeyboardKeys.q,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.w,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.e,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.r,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.t,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.y,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.u,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.i,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.o,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.p,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.a1,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.a2,
                lang: DictionaryLanguages.ru,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(),
              KeyboardKey(
                keyboardKey: KeyboardKeys.a,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.s,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.d,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.f,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.g,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.h,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.j,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.k,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.l,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.b1,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.b2,
                lang: DictionaryLanguages.ru,
              ),
              Spacer(),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              EnterKeyboardKey(lang: DictionaryLanguages.ru),
              KeyboardKey(
                keyboardKey: KeyboardKeys.z,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.x,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.c,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.v,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.b,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.n,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.m,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.c1,
                lang: DictionaryLanguages.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.c2,
                lang: DictionaryLanguages.ru,
              ),
              DeleteKeyboardKey(lang: DictionaryLanguages.ru),
            ],
          ),
        ],
      );
}
