import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/main/main_cubit.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

Future<void> showLevelResultDialog(
  final BuildContext context, {
  required final bool isWin,
  required final String word,
  required final String secretWordMeaning,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      final mainCubit = context.read<MainCubit>();
      return AlertDialog(
        backgroundColor: isWin ? AppColors.green : AppColors.red,
        title: Center(
          child: Text(
            isWin
                ? R.stringsOf(context).win_message
                : R.stringsOf(context).lose_message,
            style: AppTypography.m25.copyWith(color: Colors.white),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              width: 90,
              text: R.stringsOf(context).proceed,
              onTap: () {
                mainCubit.loadLevels();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 16),
            Text(
              R.stringsOf(context).secret_word,
              style: AppTypography.m18.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            SelectableText(
              word.toUpperCase(),
              style: AppTypography.m20.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              secretWordMeaning,
              textAlign: TextAlign.center,
              style: AppTypography.r14.copyWith(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}
