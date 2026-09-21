import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/settings/model/general.dart';

void main() {
  for (final Brightness brightness in Brightness.values) {
    testWidgets('custom letters have readable contrast in $brightness', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: Builder(
            builder: (context) {
              for (final Color background in [
                Colors.black,
                Colors.white,
                const Color(0xFF6B3333),
                const Color(0xFF777777),
                const Color(0xFF00FF00),
                const Color(0xFF0000FF),
              ]) {
                final settings = GeneralSettings(
                  locale: const Locale('en'),
                  colorMode: ColorMode.other,
                  otherColors: (background, background, background),
                );
                for (final LetterStatus status in LetterStatus.values) {
                  final Color actualBackground = status.cellColor(context, settings);
                  final Color foreground = status.textColor(context, settings)!;
                  final double a = actualBackground.computeLuminance() + 0.05;
                  final double b = foreground.computeLuminance() + 0.05;
                  expect(a > b ? a / b : b / a, greaterThanOrEqualTo(4.5));
                }
                expect(
                  LetterStatus.correctSpot.textColor(context, settings, backgroundColor: Colors.black),
                  Colors.white,
                );
                expect(
                  LetterStatus.notInWord.textColor(context, settings, backgroundColor: Colors.white),
                  Colors.black,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  }
}
