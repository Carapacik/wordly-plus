import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/theme/theme_bloc.dart';
import 'package:wordly/resources/resources.dart';

class ToggleListTile extends StatelessWidget {
  const ToggleListTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isHighContrast = context.read<ThemeBloc>().state.isHighContrast;
    return MergeSemantics(
      child: ListTileTheme.merge(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(title, style: context.theme.bl),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: isHighContrast
                ? AppColors.orange
                : context.dynamicColor(
                    light: AppColors.greenLight,
                    dark: AppColors.greenDark,
                  ),
            inactiveTrackColor: context.dynamicColor(
              light: AppColors.greyDark,
              dark: AppColors.greyLight,
            ),
          ),
          selected: value,
          enabled: onChanged != null,
          onTap: onChanged != null ? () => onChanged!(!value) : null,
        ),
      ),
    );
  }
}
