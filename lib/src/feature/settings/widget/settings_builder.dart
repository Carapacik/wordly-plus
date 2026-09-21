import 'package:flutter/widgets.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';

class const SettingsBuilder({required final Widget Function(BuildContext, Settings) builder, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => builder(context, SettingsScope.of(context, listen: true).settings);
}
