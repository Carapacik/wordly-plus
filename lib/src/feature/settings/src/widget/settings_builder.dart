import 'package:flutter/material.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/settings/settings.dart';

/// Widget that rebuilds when settings change.
class const SettingsBuilder({
  required final Widget Function(BuildContext context, Settings settings) builder,
  super.key,
}) extends StatefulWidget {
  @override
  State<SettingsBuilder> createState() => _SettingsBuilderState();
}

class _SettingsBuilderState() extends State<SettingsBuilder> {
  @override
  Widget build(BuildContext context) {
    final SettingsService service = SettingsScope.of(context).settingsService;

    return StreamBuilder(
      stream: service.stream,
      initialData: service.current,
      builder: (context, snapshot) {
        return widget.builder(
          context,
          snapshot.data ??
              Settings(
                general: GeneralSettings(locale: Localization.computeDefaultLocale()),
                dictionary: Localization.computeDefaultLocale(withDictionary: true),
              ),
        );
      },
    );
  }
}
