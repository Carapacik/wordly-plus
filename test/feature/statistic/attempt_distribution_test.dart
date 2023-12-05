import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/statistic/widget/statistic_page.dart';

void main() {
  testWidgets('renders labels 1-6 and count/max bars for [0, 8, 68, 74, 10, 0]', (tester) async {
    await tester.pumpWidget(_app(const [0, 8, 68, 74, 10, 0]));

    for (var attempt = 1; attempt <= 6; attempt++) {
      expect(find.byKey(ValueKey<String>('attempt-$attempt')), findsOneWidget);
    }
    expect(find.byKey(const ValueKey<String>('attempt-1-bar')), findsNothing);
    expect(find.byKey(const ValueKey<String>('attempt-6-bar')), findsNothing);
    expect(find.byKey(const ValueKey<String>('attempt-2-bar')), findsOneWidget);

    final FractionallySizedBox secondBar = tester.widget(
      find.ancestor(
        of: find.byKey(const ValueKey<String>('attempt-2-bar')),
        matching: find.byType(FractionallySizedBox),
      ),
    );
    expect(secondBar.widthFactor, closeTo(8 / 74, 0.0001));
  });

  testWidgets('all-zero attempts have values but no colored bars', (tester) async {
    await tester.pumpWidget(_app(const [0, 0, 0, 0, 0, 0]));

    expect(find.byKey(const ValueKey<String>('attempt-1-bar')), findsNothing);
    expect(find.byKey(const ValueKey<String>('attempt-6-bar')), findsNothing);
    expect(find.text('0'), findsNWidgets(6));
  });

  testWidgets('is readable without overflow on a narrow screen at text scale 2', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(const [0, 8, 68, 74, 10, 0], textScaler: const TextScaler.linear(2)));

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey<String>('attempt-4-value')), findsOneWidget);
  });
}

Widget _app(List<int> attempts, {TextScaler textScaler = TextScaler.noScaling}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(textScaler: textScaler),
    child: Scaffold(
      body: AttemptDistribution(attempts: attempts, color: Colors.green, textColor: Colors.white),
    ),
  ),
);
