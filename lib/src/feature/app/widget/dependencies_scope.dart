import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/utils/inherited_extension.dart';

class const DependenciesScope({
  required final DependenciesContainer dependencies,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  static DependenciesContainer of(BuildContext context) =>
      context.inhOf<_DependenciesInherited>(listen: false).dependencies;

  @override
  Widget build(BuildContext context) {
    return _DependenciesInherited(
      dependencies: dependencies,
      child: SettingsScope(
        repository: dependencies.settingsRepository,
        initialSettings: dependencies.initialSettings,
        child: child,
      ),
    );
  }
}

class const _DependenciesInherited({required super.child, required final DependenciesContainer dependencies})
    extends InheritedWidget {
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
