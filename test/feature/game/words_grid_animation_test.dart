import 'package:flutter/material.dart' hide GridTile;
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/game/widget/words_grid.dart';
import 'package:wordly/src/feature/settings/settings.dart';

void main() {
  testWidgets('evaluated letters reveal with a flip animation after Enter', (tester) async {
    var info = const LetterInfo(letter: 'a');
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox.square(
            dimension: 60,
            child: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return GridTile(
                  info: info,
                  position: 0,
                  generalSettings: const GeneralSettings(locale: Locale('en')),
                );
              },
            ),
          ),
        ),
      ),
    );

    update(() => info = const LetterInfo(letter: 'a', status: LetterStatus.correctSpot));
    await tester.pump();

    Transform transform = tester.widget(find.byKey(const ValueKey<String>('submitted-letter-animation-0')));
    expect(transform.transform.storage[5].abs(), lessThan(0.01));

    await tester.pumpAndSettle();
    transform = tester.widget(find.byKey(const ValueKey<String>('submitted-letter-animation-0')));
    expect(transform.transform.storage[5], closeTo(1, 0.001));
  });
}
