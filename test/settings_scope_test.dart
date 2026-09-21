import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/settings/data/settings_repository.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_builder.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';

const _initial = Settings(
  general: GeneralSettings(locale: Locale('en')),
  dictionary: Locale('en'),
);

void main() {
  testWidgets('queued edits preserve earlier changes and publish only after saving', (tester) async {
    final repository = _Repository()..pending = Completer<void>();
    final key = GlobalKey<SettingsScopeState>();
    await tester.pumpWidget(
      SettingsScope(
        key: key,
        repository: repository,
        initialSettings: _initial,
        child: SettingsBuilder(
          builder: (context, settings) =>
              Text('${settings.hardMode}:${settings.dictionary.languageCode}', textDirection: TextDirection.ltr),
        ),
      ),
    );
    final SettingsScopeState scope = key.currentState!;
    final Future<bool> first = scope.update((settings) => settings.copyWith(hardMode: true));
    final Future<bool> second = scope.update((settings) => settings.copyWith(dictionary: const Locale('ru')));
    await tester.pump();
    expect(scope.isSaving, isTrue);
    expect(scope.settings, _initial);
    expect(repository.saves, hasLength(1));
    expect(find.text('false:en'), findsOneWidget);
    repository.pending!.complete();
    expect(await first, isTrue);
    expect(await second, isTrue);
    await tester.pump();
    expect(scope.isSaving, isFalse);
    expect(repository.saved.hardMode, isTrue);
    expect(repository.saved.dictionary, const Locale('ru'));
    expect(find.text('true:ru'), findsOneWidget);
  });

  testWidgets('failed saves retain committed settings and can be retried', (tester) async {
    final repository = _Repository()..fail = true;
    final key = GlobalKey<SettingsScopeState>();
    await tester.pumpWidget(
      SettingsScope(key: key, repository: repository, initialSettings: _initial, child: const SizedBox()),
    );
    final SettingsScopeState scope = key.currentState!;
    expect(await scope.update((settings) => settings.copyWith(hardMode: true)), isFalse);
    await tester.pump();
    expect(scope.settings, _initial);
    expect(scope.error, isA<StateError>());
    expect(scope.isSaving, isFalse);
    repository.fail = false;
    expect(await scope.retry(), isTrue);
    await tester.pump();
    expect(scope.settings.hardMode, isTrue);
    expect(scope.error, isNull);
    expect(repository.saved, scope.settings);
  });

  testWidgets('disposing during a save does not rebuild or execute queued edits', (tester) async {
    final repository = _Repository()..pending = Completer<void>();
    final key = GlobalKey<SettingsScopeState>();
    await tester.pumpWidget(
      SettingsScope(key: key, repository: repository, initialSettings: _initial, child: const SizedBox()),
    );
    final SettingsScopeState scope = key.currentState!;
    final Future<bool> first = scope.update((settings) => settings.copyWith(hardMode: true));
    final Future<bool> second = scope.update((settings) => settings.copyWith(dictionary: const Locale('ru')));
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    repository.pending!.complete();
    expect(await first, isTrue);
    expect(await second, isFalse);
    expect(repository.saves, hasLength(1));
    expect(tester.takeException(), isNull);
  });
}

class _Repository() implements ISettingsRepository {
  Settings saved = _initial;
  final saves = <Settings>[];
  Completer<void>? pending;
  bool fail = false;

  @override
  Future<Settings> read() async => saved;

  @override
  Future<void> save(Settings settings) async {
    saves.add(settings);
    await pending?.future;
    if (fail) {
      throw StateError('Storage unavailable');
    }
    saved = settings;
  }
}
