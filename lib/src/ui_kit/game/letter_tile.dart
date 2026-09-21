import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/ui_kit/colors.dart';

class const LetterTile({
  required final LetterInfo info,
  final bool selected = false,
  final VoidCallback? onTap,
  final Color? color,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsScopeState settingsScope = SettingsScope.of(context, listen: true);
    final Settings settings = settingsScope.settings;
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 60, maxWidth: 60),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color ?? info.status.cellColor(context, settings.general),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 3, color: selected ? AppColors.red : Colors.transparent),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: FittedBox(
                child: Text(
                  info.letter.toUpperCase(),
                  style: TextStyle(
                    color: info.status.textColor(context, settings.general, backgroundColor: color),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
