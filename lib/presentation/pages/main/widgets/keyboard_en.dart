import 'package:flutter/material.dart';
import 'package:wordly/data/models/keyboard_keys.dart';
import 'package:wordly/presentation/pages/main/widgets/keyboard_key.dart';

class KeyboardEn extends StatelessWidget {
  const KeyboardEn({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              KeyboardKey(keyboardKey: KeyboardKeys.q),
              KeyboardKey(keyboardKey: KeyboardKeys.w),
              KeyboardKey(keyboardKey: KeyboardKeys.e),
              KeyboardKey(keyboardKey: KeyboardKeys.r),
              KeyboardKey(keyboardKey: KeyboardKeys.t),
              KeyboardKey(keyboardKey: KeyboardKeys.y),
              KeyboardKey(keyboardKey: KeyboardKeys.u),
              KeyboardKey(keyboardKey: KeyboardKeys.i),
              KeyboardKey(keyboardKey: KeyboardKeys.o),
              KeyboardKey(keyboardKey: KeyboardKeys.p),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(),
              KeyboardKey(keyboardKey: KeyboardKeys.a),
              KeyboardKey(keyboardKey: KeyboardKeys.s),
              KeyboardKey(keyboardKey: KeyboardKeys.d),
              KeyboardKey(keyboardKey: KeyboardKeys.f),
              KeyboardKey(keyboardKey: KeyboardKeys.g),
              KeyboardKey(keyboardKey: KeyboardKeys.h),
              KeyboardKey(keyboardKey: KeyboardKeys.j),
              KeyboardKey(keyboardKey: KeyboardKeys.k),
              KeyboardKey(keyboardKey: KeyboardKeys.l),
              Spacer(),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              EnterKeyboardKey(),
              KeyboardKey(keyboardKey: KeyboardKeys.z),
              KeyboardKey(keyboardKey: KeyboardKeys.x),
              KeyboardKey(keyboardKey: KeyboardKeys.c),
              KeyboardKey(keyboardKey: KeyboardKeys.v),
              KeyboardKey(keyboardKey: KeyboardKeys.b),
              KeyboardKey(keyboardKey: KeyboardKeys.n),
              KeyboardKey(keyboardKey: KeyboardKeys.m),
              DeleteKeyboardKey(),
            ],
          ),
        ],
      );
}
