import 'package:flutter/widgets.dart';
import 'package:wordly/src/localization/generated/l10n.dart';

extension LocalizationContext on BuildContext {
  GeneratedLocalizations get l10n => GeneratedLocalizations.of(this);
}
