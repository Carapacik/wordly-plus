import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/localization/localization_context.dart';

enum WordError() {
  notFound,
  tooShort,
  hardModePosition,
  hardModeMissingLetters;

  String localizedText(BuildContext context) => switch (this) {
    WordError.notFound => context.l10n.wordNotFound,
    WordError.tooShort => context.l10n.wordTooShort,
    WordError.hardModePosition => context.l10n.hardModePosition,
    WordError.hardModeMissingLetters => context.l10n.hardModeMissingLetters,
  };
}
