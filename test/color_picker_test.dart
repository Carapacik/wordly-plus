import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/localization/localization.dart';
import 'package:wordly/src/ui_kit/controls/color_picker.dart';

void main() {
  testWidgets('palette, hue and hex stay synchronized and accept external colors', (tester) async {
    var selected = const Color(0xFFFF0000);
    late StateSetter rebuild;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: Localization.localizationDelegates,
        supportedLocales: Localization.supportedLocales,
        locale: const Locale('en'),
        home: StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return Scaffold(
              body: ColorPicker(color: selected, onChanged: (color) => setState(() => selected = color)),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    final Finder palette = find.byKey(const ValueKey('color-palette'));
    final Finder hue = find.byKey(const ValueKey('color-hue'));
    final Rect hueRect = tester.getRect(hue);
    await tester.tapAt(Offset(hueRect.left + hueRect.width * 2 / 3, hueRect.center.dy));
    await tester.pump();
    expect(selected.toARGB32(), 0xFF0000FF);
    final Rect rect = tester.getRect(palette);
    await tester.tapAt(rect.center);
    await tester.pump();
    expect(selected.toARGB32(), 0xFF404080);
    expect(find.text('404080'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(HSVColor.fromColor(selected).saturation, greaterThan(0.5));
    rebuild(() => selected = const Color(0xFF00FF00));
    await tester.pump();
    expect(find.text('00FF00'), findsOneWidget);
  });

  testWidgets('hex accepts paste and lowercase, rejects incomplete or invalid submissions', (tester) async {
    Color? selected;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: Localization.localizationDelegates,
        supportedLocales: Localization.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: ColorPicker(color: Colors.red, onChanged: (color) => selected = color),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '#6b3333');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(selected!.toARGB32(), 0xFF6B3333);
    expect(find.text('6B3333'), findsOneWidget);
    for (final value in ['12', 'GGGGGG']) {
      await tester.enterText(find.byType(TextField), value);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(selected!.toARGB32(), 0xFF6B3333);
      expect(find.textContaining('Enter 6 hex digits'), findsOneWidget);
    }
    await tester.enterText(find.byType(TextField), 'ffffff');
    await tester.pump();
    expect(selected!.toARGB32(), 0xFFFFFFFF);
    expect(find.textContaining('Enter 6 hex digits'), findsNothing);
  });

  testWidgets('drag clamps to palette bounds and hue survives black on a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Color? selected;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: Localization.localizationDelegates,
        supportedLocales: Localization.supportedLocales,
        locale: const Locale('ru'),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: ColorPicker(color: const Color(0xFF0000FF), onChanged: (color) => selected = color),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final Finder palette = find.byKey(const ValueKey('color-palette'));
    final Rect rect = tester.getRect(palette);
    await tester.dragFrom(rect.center, Offset(rect.width, rect.height));
    await tester.pump();
    expect(selected!.toARGB32(), 0xFF000000);
    await tester.tapAt(rect.topRight - const Offset(0.01, -0.01));
    await tester.pump();
    expect(selected!.toARGB32(), 0xFF0000FF);
    expect(find.byType(Slider), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
