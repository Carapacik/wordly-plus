import 'package:flutter/material.dart';
import 'package:wordle/data/models/keyboard_keys.dart';
import 'package:wordle/presentation/pages/main/widgets/keyboard_key.dart';

class KeyboardRu extends StatelessWidget {
  const KeyboardRu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            KeyboardKey(keyboardKey: KeyboardKeys.q, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.w, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.e, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.r, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.t, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.y, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.u, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.i, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.o, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.p, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.a1, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.a2, lang: 1),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(),
            KeyboardKey(keyboardKey: KeyboardKeys.a, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.s, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.d, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.f, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.g, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.h, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.j, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.k, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.l, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.b1, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.b2, lang: 1),
            Spacer(),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            EnterKeyboardKey(lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.z, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.x, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.c, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.v, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.b, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.n, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.m, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.c1, lang: 1),
            KeyboardKey(keyboardKey: KeyboardKeys.c2, lang: 1),
            DeleteKeyboardKey(lang: 1),
          ],
        ),
      ],
    );
  }
}
