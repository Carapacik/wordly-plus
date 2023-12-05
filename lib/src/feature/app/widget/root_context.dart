import 'package:flutter/material.dart';
import 'package:wordly/src/core/ui_lib/ui_library.dart';
import 'package:wordly/src/feature/app/logic/composition_root.dart';
import 'package:wordly/src/feature/app/widget/bloc_scope.dart';
import 'package:wordly/src/feature/app/widget/dependencies_scope.dart';
import 'package:wordly/src/feature/app/widget/material_context.dart';

/// [RootContext] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it should be
/// placed here.
class const RootContext({required final CompositionResult compositionResult, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: compositionResult.dependencies,
      child: const BlocScope(child: WindowSizeScope(child: MaterialContext())),
    );
  }
}
