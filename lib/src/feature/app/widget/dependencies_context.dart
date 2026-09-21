import 'package:flutter/widgets.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/app/widget/dependencies_scope.dart';

extension DependenciesContext on BuildContext {
  DependenciesContainer get dependencies => DependenciesScope.of(this);
}
