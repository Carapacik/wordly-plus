import 'package:flutter/material.dart';
import 'package:wordly/src/core/resources/resources.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';

class const LetterTile({
  required final LetterInfo info,
  final bool selected = false,
  final VoidCallback? onTap,
  final Color? color,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsContainer settingsScope = SettingsScope.of(context, listen: true);
    final Settings settings = settingsScope.settingsService.current;
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 60, maxWidth: 60),
          decoration: BoxDecoration(
            color: color ?? info.status.cellColor(context, settings.general),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 3, color: selected ? AppColors.red : Colors.transparent),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FittedBox(
              child: Text(
                info.letter.toUpperCase(),
                style: TextStyle(color: info.status.textColor(context, settings.general), fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
