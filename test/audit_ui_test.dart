import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/app/widget/initialization_failed_app.dart';
import 'package:wordly/src/feature/game/model/game_mode.dart';
import 'package:wordly/src/feature/game/widget/game_result_dialog.dart';
import 'package:wordly/src/feature/game/widget/keyboard_by_language.dart';
import 'package:wordly/src/feature/level/widget/level_dialog.dart';
import 'package:wordly/src/feature/settings/data/settings_repository.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/localization/localization.dart';

void main() {
  for (final language in ['en', 'ru']) {
    testWidgets('keyboard actions have localized accessible labels: $language', (tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            localizationsDelegates: Localization.localizationDelegates,
            supportedLocales: Localization.supportedLocales,
            home: Scaffold(
              body: Row(
                children: [
                  EnterKey(
                    generalSettings: GeneralSettings(locale: Locale(language)),
                    dictionary: Locale(language),
                  ),
                  DeleteKey(
                    generalSettings: GeneralSettings(locale: Locale(language)),
                    dictionary: Locale(language),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel(language == 'ru' ? 'Проверить слово' : 'Submit guess'), findsWidgets);
        expect(find.bySemanticsLabel(language == 'ru' ? 'Удалить букву' : 'Delete letter'), findsWidgets);
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('startup failure is localized and retry is single flight: $language', (tester) async {
      tester.platformDispatcher.localeTestValue = Locale(language);
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      final gate = Completer<void>();
      var calls = 0;
      await tester.pumpWidget(
        InitializationFailedApp(
          error: StateError('private diagnostic'),
          stackTrace: StackTrace.current,
          onRetryInitialization: () {
            calls++;
            return gate.future;
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('private diagnostic'), findsNothing);
      final Finder retry = find.text(language == 'ru' ? 'Повторить' : 'Retry');
      expect(retry, findsOneWidget);
      await tester.tap(retry);
      await tester.pump();
      expect(tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);
      expect(calls, 1);
      await tester.pumpWidget(const SizedBox());
      gate.complete();
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('long definitions scroll at large text scale: $language', (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      late BuildContext pageContext;
      await tester.pumpWidget(
        SettingsScope(
          repository: const _SettingsRepository(),
          initialSettings: const Settings(
            general: GeneralSettings(locale: Locale('en')),
            dictionary: Locale('en'),
          ),
          child: MaterialApp(
            locale: Locale(language),
            localizationsDelegates: Localization.localizationDelegates,
            supportedLocales: Localization.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: Builder(
              builder: (context) {
                pageContext = context;
                return const Scaffold();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final String meaning = List.filled(50, 'Definition.').join(' ');
      unawaited(
        showGameResultDialog(pageContext, 'APPLE', meaning, GameMode.lvl, isWin: true, nextLevelPressed: () {}),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final ScrollableState scroll = tester.state<ScrollableState>(find.byType(Scrollable).first);
      expect(scroll.position.maxScrollExtent, greaterThan(0));
      Navigator.of(pageContext).pop();
      await tester.pumpAndSettle();
      unawaited(showLevelDialog(pageContext, word: 'APPLE', meaning: meaning, isWin: true));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.state<ScrollableState>(find.byType(Scrollable).first).position.maxScrollExtent, greaterThan(0));
    });
  }
}

final class const _SettingsRepository() implements ISettingsRepository {
  @override
  Future<Settings> read() async => const Settings(
    general: GeneralSettings(locale: Locale('en')),
    dictionary: Locale('en'),
  );

  @override
  Future<void> save(Settings settings) async {}
}
