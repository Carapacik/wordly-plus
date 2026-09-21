import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/app/widget/dependencies_scope.dart';
import 'package:wordly/src/feature/game/data/game_repository.dart';
import 'package:wordly/src/feature/game/logic/game_bloc.dart';
import 'package:wordly/src/feature/game/model/game_mode.dart';
import 'package:wordly/src/feature/game/model/game_result.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/game/model/word_error.dart';
import 'package:wordly/src/feature/game/widget/game_page.dart';
import 'package:wordly/src/feature/game/widget/game_result_dialog.dart';
import 'package:wordly/src/feature/game/widget/keyboard_by_language.dart';
import 'package:wordly/src/feature/level/data/level_repository.dart';
import 'package:wordly/src/feature/level/model/level_result.dart';
import 'package:wordly/src/feature/level/widget/level_page.dart';
import 'package:wordly/src/feature/settings/data/settings_local_datasource.dart';
import 'package:wordly/src/feature/settings/data/settings_repository.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/feature/statistic/data/statistics_repository.dart';
import 'package:wordly/src/feature/statistic/model/game_statistic.dart';
import 'package:wordly/src/feature/statistic/widget/statistic_page.dart';
import 'package:wordly/src/localization/localization.dart';

void main() {
  for (final levels in [false, true]) {
    testWidgets('history separates loading, error and retry: levels=$levels', (tester) async {
      final SharedPreferencesAsyncPlatform? previous = SharedPreferencesAsyncPlatform.instance;
      SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
      addTearDown(() => SharedPreferencesAsyncPlatform.instance = previous);
      final levelGate = Completer<List<LevelResult>>();
      final statisticGate = Completer<GameStatistic?>();
      final levelRepository = _LevelRepository()..historyGate = levels ? levelGate : null;
      final statistics = _ReadStatistics()..gate = levels ? null : statisticGate;
      final dependencies = DependenciesContainer(
        packageInfo: PackageInfo(appName: 'Wordly', packageName: 'wordly', version: 'test', buildNumber: '1'),
        settingsRepository: SettingsRepository(
          localDatasource: SettingsLocalDatasourceSharedPreferences(sharedPreferences: SharedPreferencesAsync()),
        ),
        initialSettings: const Settings(
          general: GeneralSettings(locale: Locale('ru')),
          dictionary: Locale('ru'),
        ),
        statisticsRepository: statistics,
        levelRepository: levelRepository,
        gameRepository: _GameRepository(),
      );
      await tester.pumpWidget(
        DependenciesScope(
          dependencies: dependencies,
          child: MaterialApp(
            locale: const Locale('ru'),
            localizationsDelegates: Localization.localizationDelegates,
            supportedLocales: Localization.supportedLocales,
            home: levels ? const LevelPage(dictionary: Locale('ru')) : const StatisticPage(dictionary: Locale('ru')),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      if (levels) {
        levelGate.completeError(StateError('read failed'));
      } else {
        statisticGate.completeError(StateError('read failed'));
      }
      await tester.pumpAndSettle();
      expect(find.text('Не удалось загрузить данные. Повторите попытку.'), findsOneWidget);
      expect(find.text('Вы не сыграли ни одной игры'), findsNothing);
      await tester.tap(find.text('Повторить'));
      await tester.pumpAndSettle();
      expect(find.text('Не удалось загрузить данные. Повторите попытку.'), findsNothing);
      expect(find.text('Вы не сыграли ни одной игры'), findsOneWidget);
    });
  }

  test('failed dictionary load blocks input and retry restores selected dictionary', () async {
    final repository = _GameRepository()..loadFailuresRemaining = 1;
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: repository,
      levelRepository: _LevelRepository(),
      savedResult: null,
    );
    addTearDown(bloc.close);
    bloc.add(const GameEvent.changeDictionary(Locale('ru')));
    final GamePersistenceFailure failure = await _waitForPersistenceFailure(bloc);
    expect(failure.dictionary, const Locale('ru'));
    expect(failure.operation, GamePersistenceOperation.loadGame);
    expect(failure.board, isEmpty);
    expect(failure.isInputBlocked, isTrue);
    final Future<GameState> restored = bloc.stream.firstWhere((state) => !state.isPersistenceFailure);
    bloc.add(const GameEvent.retryLevelPersistence());
    expect((await restored).dictionary, const Locale('ru'));
    expect(bloc.state.secretWord, 'apple');
  });

  testWidgets('game stays within 840 while app bar and drawer use the full window', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 1000);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final SharedPreferencesAsyncPlatform? previousPreferencesPlatform = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    addTearDown(() => SharedPreferencesAsyncPlatform.instance = previousPreferencesPlatform);
    final settingsRepository = SettingsRepository(
      localDatasource: SettingsLocalDatasourceSharedPreferences(sharedPreferences: SharedPreferencesAsync()),
    );
    final Settings settings = await settingsRepository.read();
    final levelRepository = _LevelRepository();
    final gameRepository = _GameRepository();
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: gameRepository,
      levelRepository: levelRepository,
      savedResult: null,
    );
    addTearDown(bloc.close);
    final dependencies = DependenciesContainer(
      packageInfo: PackageInfo(appName: 'Wordly', packageName: 'wordly', version: 'test', buildNumber: '1'),
      settingsRepository: settingsRepository,
      initialSettings: settings,
      statisticsRepository: const _StatisticsRepository(),
      levelRepository: levelRepository,
      gameRepository: gameRepository,
    );
    await tester.pumpWidget(
      DependenciesScope(
        dependencies: dependencies,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: Localization.localizationDelegates,
          supportedLocales: Localization.supportedLocales,
          home: BlocProvider<GameBloc>.value(value: bloc, child: const GamePage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    tester.view.padding = const FakeViewPadding(left: 20, right: 16, top: 24, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(left: 20, right: 16, top: 24, bottom: 34);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);
    for (final locale in [const Locale('en'), const Locale('ru')]) {
      await SettingsScope.of(tester.element(find.byType(GameBody)))
          .update((current) => current.copyWith(dictionary: locale));
      for (final size in [
        const Size(1440, 1000),
        const Size(1920, 360),
        const Size(840, 700),
        const Size(375, 667),
        const Size(375, 320),
        const Size(320, 568),
        const Size(700, 360),
      ]) {
        tester.view.physicalSize = size;
        await tester.pumpAndSettle();
        final Rect appBar = tester.getRect(find.byType(AppBar));
        expect(appBar.width, size.width);
        expect(appBar.center.dx, closeTo(size.width / 2, 1));
        expect(tester.getSize(find.byType(GameBody)).width, lessThanOrEqualTo(840));
        final Rect body = tester.getRect(find.byType(GameBody));
        for (final Element element in find.byType(KeyboardKey).evaluate()) {
          final Rect key = tester.getRect(find.byWidget(element.widget));
          expect(key.left, greaterThanOrEqualTo(body.left + 20 + 8));
          expect(key.right, lessThanOrEqualTo(body.right - 16 - 8));
        }
        if (size.height <= 360) {
          await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
          await tester.pumpAndSettle();
          final Rect enter = tester.getRect(find.byType(EnterKey));
          expect(enter.bottom, lessThanOrEqualTo(body.bottom - 34 - 8));
          expect(enter.top, greaterThanOrEqualTo(body.top));
        }
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(DrawerButton));
        await tester.pumpAndSettle();
        expect(tester.getRect(find.byType(Drawer)).left, 0);
        final ScaffoldState scaffold = tester.state(find.byType(Scaffold).first);
        expect(scaffold.isDrawerOpen, isTrue);
        scaffold.closeDrawer();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
  });
  for (final GameMode mode in GameMode.values) {
    test('hard mode rejects without consuming a guess and can be disabled in $mode', () async {
      var hardMode = true;
      final List<LetterInfo> board = [
        for (final letter in 'cider'.split(''))
          LetterInfo(letter: letter, status: letter == 'e' ? LetterStatus.wrongSpot : LetterStatus.notInWord),
      ];
      final progress = GameResult(secretWord: 'apple', board: board, lvlNumber: 1);
      final bloc = GameBloc(
        dictionary: const Locale('en'),
        gameRepository: _GameRepository(),
        levelRepository: _LevelRepository(progress: progress),
        savedResult: progress,
        isHardMode: () => hardMode,
      );
      addTearDown(bloc.close);
      if (mode == GameMode.lvl) {
        await _enterLevelMode(bloc);
      }
      final Future<GameState> failure = bloc.stream.firstWhere((state) => state is GameFailure);
      await _enterWord(bloc, 'crank');
      expect((await failure as GameFailure).error, WordError.hardModeMissingLetters);
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.currentWordIndex, 1);
      expect(bloc.state.board.take(5), board);
      expect(bloc.state.board.skip(5).every((letter) => letter.status == LetterStatus.unknown), isTrue);
      hardMode = false;
      final Future<GameState> accepted = bloc.stream.firstWhere(
        (state) => state.board.last.status != LetterStatus.unknown,
      );
      bloc.add(const GameEvent.enterPressed());
      await accepted;
      expect(bloc.state.board, hasLength(10));
    });
  }
  test('does not publish win until completeLevel commits', () async {
    final levelRepository = _LevelRepository()..completionGate = Completer<void>();
    final GameBloc bloc = _bloc(levelRepository);
    addTearDown(bloc.close);
    await _enterLevelMode(bloc);

    final Future<void> entered = _enterWord(bloc, 'apple');
    while (levelRepository.completions.isEmpty) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(bloc.state, isNot(isA<GameWin>()));

    final Future<GameState> win = bloc.stream.firstWhere((state) => state is GameWin);
    levelRepository.completionGate!.complete();
    await entered;
    await win;
    expect(levelRepository.completions, hasLength(1));
  });

  test('next level read failures can be retried without completing the level again', () async {
    final repository = _LevelRepository();
    final GameBloc bloc = _bloc(repository);
    addTearDown(bloc.close);
    await _enterLevelMode(bloc);
    final Future<GameState> win = bloc.stream.firstWhere((state) => state is GameWin);
    await _enterWord(bloc, 'apple');
    await win;
    repository.loadFailuresRemaining = 2;
    bloc.add(const GameEvent.resetBoard(GameMode.lvl));
    final GamePersistenceFailure failed = await _waitForPersistenceFailure(bloc);
    expect(failed.operation, GamePersistenceOperation.loadNextLevel);
    expect(failed.isInputBlocked, isTrue);
    expect(failed.lvlNumber, 1);

    final Future<GameState> failedAgain = bloc.stream.firstWhere(
      (state) => state is GamePersistenceFailure && state.retryCount == 1,
    );
    bloc
      ..add(const GameEvent.letterPressed('x'))
      ..add(const GameEvent.changeGameMode(GameMode.daily))
      ..add(const GameEvent.retryLevelPersistence());
    await failedAgain;
    expect(bloc.state.board, failed.board);
    expect(bloc.state.gameMode, GameMode.lvl);

    final Future<GameState> recovered = bloc.stream.firstWhere((state) => state is GameIdle);
    bloc.add(const GameEvent.retryLevelPersistence());
    await recovered;
    expect(bloc.state.lvlNumber, 2);
    expect(bloc.state.secretWord, 'berry');
    expect(bloc.state.board, isEmpty);
    expect(bloc.state.isInputBlocked, isFalse);
    expect(repository.completions, hasLength(1));
    expect(repository.successfulCompletionKeys, {'en:1'});
  });

  test('failure keeps generated progress and Retry uses it without duplicate result', () async {
    final levelRepository = _LevelRepository()..failuresRemaining = 1;
    final GameBloc bloc = _bloc(levelRepository);
    addTearDown(bloc.close);
    await _enterLevelMode(bloc);

    await _enterWord(bloc, 'apple');
    final GamePersistenceFailure failed = await _waitForPersistenceFailure(bloc);
    final GameResult pending = failed.pendingProgress;
    expect(failed.gameCompleted, isFalse);
    expect(failed.isInputBlocked, isTrue);
    expect(failed.board, hasLength(5));

    final Future<GameState> resultFuture = bloc.stream.firstWhere((state) => state is GameWin);
    bloc.add(const GameEvent.retryLevelPersistence());
    final GameState result = await resultFuture;

    expect(result.gameCompleted, isTrue);
    expect(levelRepository.completions, hasLength(2));
    expect(identical(levelRepository.completions[0].$2, pending), isTrue);
    expect(identical(levelRepository.completions[1].$2, pending), isTrue);
    expect(levelRepository.successfulCompletionKeys, {'en:1'});
  });

  test('successful Retry publishes a completed GameLoss after a failed loss commit', () async {
    final previousGuesses = List<LetterInfo>.generate(
      25,
      (index) => LetterInfo(letter: 'cider'[index % 5], status: LetterStatus.notInWord),
    );
    final levelRepository = _LevelRepository(
      progress: GameResult(secretWord: 'apple', lvlNumber: 1, board: previousGuesses),
    )..failuresRemaining = 1;
    final GameBloc bloc = _bloc(levelRepository);
    addTearDown(bloc.close);
    await _enterLevelMode(bloc);

    await _enterWord(bloc, 'cider');
    final GamePersistenceFailure failed = await _waitForPersistenceFailure(bloc);
    expect(failed.gameCompleted, isFalse);
    expect(failed.pendingIsWin, isFalse);

    bloc.add(const GameEvent.retryLevelPersistence());
    for (var iteration = 0; iteration < 100 && bloc.state is GamePersistenceFailure; iteration++) {
      await Future<void>.delayed(Duration.zero);
    }
    final GameState result = bloc.state;

    expect(result, isA<GameLoss>());
    expect(result.gameCompleted, isTrue);
    expect(levelRepository.completions, hasLength(2));
    expect(levelRepository.successfulCompletionKeys, {'en:1'});
  });

  testWidgets('Retry hides the error Snackbar and opens one result dialog', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final SharedPreferencesAsyncPlatform? previousPreferencesPlatform = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    addTearDown(() => SharedPreferencesAsyncPlatform.instance = previousPreferencesPlatform);
    final settingsRepository = SettingsRepository(
      localDatasource: SettingsLocalDatasourceSharedPreferences(sharedPreferences: SharedPreferencesAsync()),
    );
    final Settings settings = await settingsRepository.read();
    final levelRepository = _LevelRepository()..failuresRemaining = 1;
    final gameRepository = _GameRepository();
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: gameRepository,
      levelRepository: levelRepository,
      savedResult: null,
    );
    addTearDown(bloc.close);
    final dependencies = DependenciesContainer(
      packageInfo: PackageInfo(appName: 'Wordly', packageName: 'wordly', version: 'test', buildNumber: '1'),
      settingsRepository: settingsRepository,
      initialSettings: settings,
      statisticsRepository: const _StatisticsRepository(),
      levelRepository: levelRepository,
      gameRepository: gameRepository,
    );
    await tester.pumpWidget(
      DependenciesScope(
        dependencies: dependencies,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: Localization.localizationDelegates,
          supportedLocales: Localization.supportedLocales,
          home: BlocProvider<GameBloc>.value(
            value: bloc,
            child: const Scaffold(body: GameBody()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _enterLevelMode(bloc);
    await tester.pump();

    await _enterWord(bloc, 'apple');
    while (bloc.state is! GamePersistenceFailure) {
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
    expect((bloc.state as GamePersistenceFailure).gameCompleted, isFalse);

    await tester.tap(find.byType(SnackBarAction));
    await tester.pumpAndSettle();

    expect(find.byType(DialogContent), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(bloc.state, isA<GameWin>());
    expect(bloc.state.gameCompleted, isTrue);
    expect(levelRepository.completions, hasLength(2));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(DialogContent), findsOneWidget);

    levelRepository.loadFailuresRemaining = 1;
    await tester.tap(find.text('Next level'));
    await tester.pumpAndSettle();
    expect(find.byType(DialogContent), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(bloc.state, isA<GamePersistenceFailure>());

    await tester.tap(find.byType(SnackBarAction));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
    expect(find.byType(DialogContent), findsNothing);
    expect(bloc.state, isA<GameIdle>());
    expect(bloc.state.lvlNumber, 2);
    expect(bloc.state.secretWord, 'berry');
    expect(levelRepository.completions, hasLength(2));
  });

  test('rapid repeated completion events create one completion', () async {
    final levelRepository = _LevelRepository();
    final GameBloc bloc = _bloc(levelRepository);
    addTearDown(bloc.close);
    await _enterLevelMode(bloc);
    for (final String letter in 'apple'.split('')) {
      bloc.add(GameEvent.letterPressed(letter));
    }
    await bloc.stream.firstWhere((state) => state.board.length == 5);

    bloc
      ..add(const GameEvent.enterPressed())
      ..add(const GameEvent.enterPressed());
    await bloc.stream.firstWhere((state) => state is GameWin);
    await Future<void>.delayed(Duration.zero);

    expect(levelRepository.completions, hasLength(1));
  });

  test('restored keyboard keeps correct over wrong and absent statuses', () async {
    final board = <LetterInfo>[
      const LetterInfo(letter: 'a', status: LetterStatus.correctSpot),
      const LetterInfo(letter: 'a', status: LetterStatus.wrongSpot),
      const LetterInfo(letter: 'a', status: LetterStatus.notInWord),
      const LetterInfo(letter: 'b', status: LetterStatus.notInWord),
      const LetterInfo(letter: 'b', status: LetterStatus.wrongSpot),
    ];
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: _GameRepository(),
      levelRepository: _LevelRepository(),
      savedResult: GameResult(secretWord: 'apple', board: board),
    );
    addTearDown(bloc.close);

    expect(bloc.state.statuses['a'], LetterStatus.correctSpot);
    expect(bloc.state.statuses['b'], LetterStatus.wrongSpot);
  });

  test('loss sharing reports loss, not win', () {
    const state = GameState.loss(
      dictionary: Locale('en'),
      secretWord: 'apple',
      gameMode: GameMode.daily,
      gameCompleted: true,
      board: [],
      statuses: {},
      lvlNumber: null,
    );

    expect(state.buildResultString!.$1, isFalse);
  });

  test('saved answer remains playable after removal from the dictionary', () async {
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: _GameRepository(),
      levelRepository: _LevelRepository(),
      savedResult: const GameResult(secretWord: 'berry'),
    );
    addTearDown(bloc.close);
    expect(_GameRepository().containsWord(const Locale('en'), 'berry'), isFalse);
    expect(bloc.state.secretWord, 'berry');
    final Future<GameState> completed = bloc.stream.firstWhere((state) => state.isWin);
    await _enterWord(bloc, 'berry');
    expect((await completed).secretWord, 'berry');
  });
  test('daily rolls over before accepting input and restores the new date', () async {
    var now = DateTime.utc(2026, 9, 1, 23, 59, 59);
    final repo = _GameRepository();
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: repo,
      levelRepository: _LevelRepository(),
      savedResult: null,
      clock: () => now,
    );
    addTearDown(bloc.close);
    bloc.add(const GameEvent.letterPressed('a'));
    await bloc.stream.firstWhere((s) => s.board.length == 1);
    repo.daily['en:2026-09-02'] = const GameResult(secretWord: 'berry');
    now = DateTime.utc(2026, 9, 2);
    bloc.add(const GameEvent.enterPressed());
    await bloc.stream.firstWhere((s) => s.secretWord == 'berry');
    expect(bloc.dailyDate, DateTime.utc(2026, 9, 2));
    expect(bloc.state.board, isEmpty);
    expect(repo.writes, isEmpty);
  });

  test('daily completion waits for commit and keeps its date across midnight', () async {
    var now = DateTime.utc(2026, 9, 1, 23, 59, 59);
    final repo = _GameRepository()..saveGate = Completer<void>();
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: repo,
      levelRepository: _LevelRepository(),
      savedResult: null,
      clock: () => now,
    );
    addTearDown(bloc.close);
    await _enterWord(bloc, 'apple');
    while (repo.writes.isEmpty) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(bloc.state.isResult, isFalse);
    now = DateTime.utc(2026, 9, 2);
    final Future<GameState> won = bloc.stream.firstWhere((s) => s.isWin);
    repo.saveGate!.complete();
    await won;
    expect(repo.writes.single.$1, DateTime.utc(2026, 9));
    expect(repo.writes.single.$2.dailyDate, DateTime.utc(2026, 9));
    bloc.add(const GameEvent.refreshDaily());
    await bloc.stream.firstWhere((s) => !s.gameCompleted);
    expect(bloc.dailyDate, DateTime.utc(2026, 9, 2));
    expect(bloc.state.board, isEmpty);
  });

  test('failed daily save blocks switching and retries original date after midnight', () async {
    var now = DateTime.utc(2026, 9, 1, 23, 59, 59);
    final repo = _GameRepository()..failuresRemaining = 1;
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: repo,
      levelRepository: _LevelRepository(),
      savedResult: null,
      clock: () => now,
    );
    addTearDown(bloc.close);
    await _enterWord(bloc, 'apple');
    await _waitForPersistenceFailure(bloc);
    now = DateTime.utc(2026, 9, 2);
    bloc
      ..add(const GameEvent.changeGameMode(GameMode.lvl))
      ..add(const GameEvent.changeDictionary(Locale('ru')))
      ..add(const GameEvent.refreshDaily());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.gameMode, GameMode.daily);
    expect(bloc.state.dictionary, const Locale('en'));
    final Future<GameState> won = bloc.stream.firstWhere((s) => s.isWin);
    bloc.add(const GameEvent.retryLevelPersistence());
    await won;
    expect(repo.writes, hasLength(2));
    expect(repo.writes.every((w) => w.$1 == DateTime.utc(2026, 9)), isTrue);
    expect(bloc.state.secretWord, 'apple');
  });

  test('daily failed progress retry resumes input without creating a result', () async {
    final repo = _GameRepository()..failuresRemaining = 1;
    final bloc = GameBloc(
      dictionary: const Locale('en'),
      gameRepository: repo,
      levelRepository: _LevelRepository(),
      savedResult: null,
    );
    addTearDown(bloc.close);
    await _enterWord(bloc, 'cider');
    await _waitForPersistenceFailure(bloc);
    final Future<GameState> resumed = bloc.stream.firstWhere((s) => !s.isPersistenceFailure);
    bloc.add(const GameEvent.retryLevelPersistence());
    await resumed;
    expect(bloc.state.gameCompleted, isFalse);
    expect(bloc.state.board, hasLength(5));
    expect(bloc.state.isInputBlocked, isFalse);
  });
}

GameBloc _bloc(_LevelRepository levelRepository) => GameBloc(
  dictionary: const Locale('en'),
  gameRepository: _GameRepository(),
  levelRepository: levelRepository,
  savedResult: null,
);

Future<void> _enterLevelMode(GameBloc bloc) async {
  bloc.add(const GameEvent.changeGameMode(GameMode.lvl));
  await bloc.stream.firstWhere((state) => state.gameMode == GameMode.lvl && state.lvlNumber == 1);
}

Future<void> _enterWord(GameBloc bloc, String word) async {
  final int targetLength = bloc.state.board.length + word.length;
  for (final String letter in word.split('')) {
    bloc.add(GameEvent.letterPressed(letter));
  }
  await bloc.stream.firstWhere((state) => state.board.length == targetLength);
  bloc.add(const GameEvent.enterPressed());
}

Future<GamePersistenceFailure> _waitForPersistenceFailure(GameBloc bloc) async {
  while (bloc.state is! GamePersistenceFailure) {
    await Future<void>.delayed(Duration.zero);
  }
  return bloc.state as GamePersistenceFailure;
}

final class _GameRepository() implements IGameRepository {
  final daily = <String, GameResult>{};
  final writes = <(DateTime, GameResult)>[];
  int failuresRemaining = 0;
  int loadFailuresRemaining = 0;
  Completer<void>? saveGate;

  String key(Locale dictionary, DateTime date) =>
      '${dictionary.languageCode}:${date.toUtc().toIso8601String().substring(0, 10)}';

  @override
  bool containsWord(Locale dictionary, String word) => const {'apple', 'cider', 'crank'}.contains(word);

  @override
  Future<String> definition(Locale dictionary, String word) async => word;

  @override
  String generateSecretWord(Locale dictionary, {int levelNumber = 0, DateTime? date}) =>
      levelNumber == 2 ? 'berry' : 'apple';

  @override
  Future<GameResult?> getDaily(Locale dictionary, DateTime date) async {
    if (loadFailuresRemaining > 0) {
      loadFailuresRemaining--;
      throw StateError('injected load failure');
    }
    return daily[key(dictionary, date)];
  }

  @override
  Future<void> init(Locale dictionary) async {}

  @override
  Future<bool> get isFirstEnter async => false;

  @override
  GameResult? get savedResult => null;

  @override
  Future<void> setDailyBoard(Locale dictionary, DateTime date, GameResult savedResult) async {
    writes.add((date, savedResult));
    await saveGate?.future;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw StateError('injected daily failure');
    }
    daily[key(dictionary, date)] = savedResult;
  }

  @override
  Future<void> setFirstEnter() async {}
}

final class _LevelRepository({final GameResult progress = const GameResult(secretWord: 'apple', lvlNumber: 1)})
    implements ILevelRepository {
  Completer<void>? completionGate;
  GameResult? completedProgress;
  int loadFailuresRemaining = 0;
  int failuresRemaining = 0;
  final List<(GameResult, GameResult)> completions = [];
  final Set<String> successfulCompletionKeys = {};
  Completer<List<LevelResult>>? historyGate;

  @override
  Future<void> completeLevel({
    required Locale dictionary,
    required GameResult completedLevel,
    required GameResult nextLevel,
  }) async {
    completions.add((completedLevel, nextLevel));
    await completionGate?.future;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw StateError('injected failure');
    }
    successfulCompletionKeys.add('${dictionary.languageCode}:${completedLevel.lvlNumber}');
    completedProgress = nextLevel;
  }

  @override
  Future<GameResult?> getCurrentProgress(Locale dictionary) async {
    if (loadFailuresRemaining > 0) {
      loadFailuresRemaining--;
      throw StateError('injected progress load failure');
    }
    return completedProgress ?? progress;
  }

  @override
  Future<List<LevelResult>> getResults(Locale dictionary) {
    final Completer<List<LevelResult>>? pending = historyGate;
    historyGate = null;
    return pending?.future ?? Future.value(const []);
  }

  @override
  Future<void> saveCurrentProgress(Locale dictionary, GameResult progress) async {}
}

final class const _StatisticsRepository() implements IStatisticsRepository {
  @override
  Future<GameStatistic?> getStatistic(String dictionary) async => null;
}

final class _ReadStatistics() implements IStatisticsRepository {
  Completer<GameStatistic?>? gate;

  @override
  Future<GameStatistic?> getStatistic(String dictionary) {
    final Completer<GameStatistic?>? pending = gate;
    gate = null;
    return pending?.future ?? Future.value();
  }
}
