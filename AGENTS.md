# WordlyPlus contributor guide

WordlyPlus is a Flutter Wordle-style application with independent English and Russian dictionaries and Daily and Level modes.

## Project map

- `lib/src/feature/`: application features, grouped into `domain`, `data`, `bloc`/`application`, and `widget` layers.
- `lib/src/core/`: shared utilities, localization, generated asset constants, resources, and UI tokens.
- `assets/dictionary/`: ordered JSON objects mapping five-letter words to definitions.
- `packages/logger/`: local workspace package used by startup and Bloc error reporting.
- `docs/`: architecture, product behavior, and persistence contracts.

## Commands

```sh
flutter pub get
dart pub global run intl_utils:generate
dart run build_runner build --delete-conflicting-outputs
dart format .
dart analyze
flutter test
flutter build web
```

Use the Flutter version required by `pubspec.yaml` (the repository also has `.fvmrc`). Run formatting, analysis, and relevant tests for every change.

## Generated code

- Freezed sources use `@Freezed` plus `part` declarations. Regenerate them with `build_runner`.
- FlutterGen owns `lib/src/core/constant/generated/`.
- `intl_utils` owns `lib/src/core/constant/localization/generated/`; edit the ARB files in `translations/` instead.
- Drift-generated `*.g.dart` files are generated with `build_runner`.
- Never edit generated files or platform plugin registrants by hand.

## Architecture and persistence rules

- Widgets depend on Bloc/application APIs; domain code must not depend on widgets or concrete persistence implementations.
- Construct repositories and databases in `feature/app/logic/composition_root.dart`; deliver them through the existing dependency scopes.
- Keep interface locale and game dictionary as independent settings.
- Keep English and Russian progress, history, boards, and statistics isolated by dictionary code.
- Settings, Daily board, Daily statistics, and first-run state remain in `SharedPreferencesAsync` unless a documented migration changes ownership.
- Level current progress and Level history belong to the same Drift repository and database.
- Completing a Level must atomically write the completed result and the next current progress in one transaction.
- Await writes that affect Level progress. Never use `unawaited` for a critical Level write.
- A failed Level transaction must not publish a successful result or expose the next level. Preserve the completed board in memory and allow retry.
- Migrations must be idempotent, validated before their marker is written, and must not delete legacy data in the current release.
- Never discard all history because one element is malformed. Preserve valid elements and log rejected ones.
- Placeholder Level results mean “the level was passed, but its result is unavailable”; they use nullable result fields and must never overwrite a real result.
- Apply the configured correct, wrong-spot, and not-in-word colors consistently to tiles, keyboard, result dialogs, Level history, and statistics.

See [architecture](docs/ARCHITECTURE.md), [product behavior](docs/PRODUCT_BEHAVIOR.md), and [persistence](docs/PERSISTENCE.md) for the complete contracts.
