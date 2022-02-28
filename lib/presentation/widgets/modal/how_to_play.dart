import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/settings/settings_cubit.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

Future<void> showHowToPlayDialog(final BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        R.stringsOf(context).how_to_play,
        style: AppTypography.m25,
      ),
      content: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.isHighContrast != current.isHighContrast,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RuleItem(
              text: R.stringsOf(context).letter_incorrect,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            _RuleItem(
              text: R.stringsOf(context).letter_incorrect_spot,
              color: state.isHighContrast
                  ? AppColors.highContrastBlue
                  : AppColors.yellow,
            ),
            const SizedBox(height: 16),
            _RuleItem(
              text: R.stringsOf(context).letter_correct,
              color: state.isHighContrast
                  ? AppColors.highContrastOrange
                  : AppColors.green,
            ),
          ],
        ),
      ),
    ),
  );
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              R.stringsOf(context).example_letter,
              style: AppTypography.m25.copyWith(color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              text,
              style: AppTypography.m16,
            ),
          ),
        ],
      );
}
