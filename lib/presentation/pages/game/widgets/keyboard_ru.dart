import 'package:flutter/material.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/presentation/pages/game/widgets/keyboard_key.dart';

class KeyboardRu extends StatelessWidget {
  const KeyboardRu({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KeyboardKey(
                keyboardKey: KeyboardKeys.q,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.w,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.e,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.r,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.t,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.y,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.u,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.i,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.o,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.p,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.a1,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.a2,
                dictionary: DictionaryEnum.ru,
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              KeyboardKey(
                keyboardKey: KeyboardKeys.a,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.s,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.d,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.f,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.g,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.h,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.j,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.k,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.l,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.b1,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.b2,
                dictionary: DictionaryEnum.ru,
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EnterKeyboardKey(dictionary: DictionaryEnum.ru),
              KeyboardKey(
                keyboardKey: KeyboardKeys.z,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.x,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.c,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.v,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.b,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.n,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.m,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.c1,
                dictionary: DictionaryEnum.ru,
              ),
              KeyboardKey(
                keyboardKey: KeyboardKeys.c2,
                dictionary: DictionaryEnum.ru,
              ),
              DeleteKeyboardKey(dictionary: DictionaryEnum.ru),
            ],
          ),
        ],
      );
}
