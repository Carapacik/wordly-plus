import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/game/logic/game_bloc.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/localization/localization_context.dart';

class const SettingsSaveError({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsScopeState scope = SettingsScope.of(context, listen: true);
    if (scope.error == null) {
      return const SizedBox.shrink();
    }
    return ListTile(
      title: Text(context.l10n.settingsSaveFailed),
      trailing: TextButton(
        onPressed: scope.isSaving
            ? null
            : () async {
                final GameBloc bloc = context.read<GameBloc>();
                if (await scope.retry()) {
                  bloc.add(GameEvent.changeDictionary(scope.settings.dictionary));
                }
              },
        child: Text(context.l10n.retry),
      ),
    );
  }
}
