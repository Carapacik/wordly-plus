import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/app/widget/bloc_scope.dart';
import 'package:wordly/src/feature/app/widget/dependencies_scope.dart';
import 'package:wordly/src/feature/app/widget/material_context.dart';

class const RootContext({required final DependenciesContainer dependencies, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: dependencies,
      child: const BlocScope(child: MaterialContext()),
    );
  }
}
