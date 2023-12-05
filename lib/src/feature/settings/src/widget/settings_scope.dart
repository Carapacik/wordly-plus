import 'package:flutter/widgets.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/settings/settings.dart';

/// A scope that provides [SettingsContainer] to its widget subtree.
class const SettingsScope({
  /// Container with settings.
  required final SettingsContainer settingsContainer,
  required super.child,
  super.key,
}) extends InheritedWidget {
  /// Get the settings from the [context].
  static SettingsContainer of(BuildContext context, {bool listen = false}) =>
      context.inhOf<SettingsScope>(listen: listen).settingsContainer;

  @override
  bool updateShouldNotify(covariant SettingsScope oldWidget) {
    return !identical(settingsContainer, oldWidget.settingsContainer);
  }
}
