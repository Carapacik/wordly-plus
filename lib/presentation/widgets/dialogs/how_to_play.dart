import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/bloc/settings/settings_cubit.dart';
import 'package:wordle/resources/app_colors.dart';
import 'package:wordle/resources/app_text_styles.dart';
import 'package:wordle/resources/r.dart';

Future<void> showHowToPlayDialog(final BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).primaryColorLight,
      title: Text(
        R.stringsOf(context).how_to_play,
        style: AppTextStyles.m25,
      ),
      content: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.isHighContrast != current.isHighContrast,
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RuleItem(
                text: R.stringsOf(context).letter_incorrect,
                color: AppColors.grey,
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
          );
        },
      ),
    ),
  );
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            style: AppTextStyles.m25,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.m16,
          ),
        ),
      ],
    );
  }
}
