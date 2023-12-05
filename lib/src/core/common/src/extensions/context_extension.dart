import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter/widgets.dart';
import 'package:wordly/src/core/constant/localization/generated/l10n.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/app/widget/dependencies_scope.dart';

extension ContextX on BuildContext {
  /// Localization of app
  GeneratedLocalizations get l10n => Localization.of(this);

  /// Get dependencies container
  DependenciesContainer get dependencies => DependenciesScope.of(this);

  /// Get theme
  ThemeData get theme => Theme.of(this);
}
