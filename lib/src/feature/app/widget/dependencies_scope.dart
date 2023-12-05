import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/settings/settings.dart';

class const DependenciesScope({
  required final DependenciesContainer dependencies,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  /// Get the dependencies from the [context].
  static DependenciesContainer of(BuildContext context) =>
      context.inhOf<_DependenciesInherited>(listen: false).dependencies;

  @override
  Widget build(BuildContext context) {
    return _DependenciesInherited(
      dependencies: dependencies,
      child: SettingsScope(settingsContainer: dependencies.settingsContainer, child: child),
    );
  }
}

/// A scope that provides composed [DependenciesContainer].
class const _DependenciesInherited({
  required super.child,

  /// Container with dependencies.
  required final DependenciesContainer dependencies,
}) extends InheritedWidget {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DependenciesContainer>('dependencies', dependencies));
  }

  @override
  bool updateShouldNotify(_DependenciesInherited oldWidget) {
    return !identical(dependencies, oldWidget.dependencies);
  }
}
