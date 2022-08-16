import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/theme/theme_bloc.dart';
import 'package:wordly/resources/resources.dart';

enum LetterStatus {
  correctSpot,
  wrongSpot,
  notInWord,
  unknown;

  const LetterStatus();

  Color itemColor(BuildContext context, {bool grid = true}) {
    final isHighContrast = context.watch<ThemeBloc>().state.isHighContrast;
    switch (this) {
      case LetterStatus.unknown:
        return grid
            ? Colors.transparent
            : context.dynamicColor(
                light: AppColors.lightGrey,
                dark: AppColors.darkGrey,
              );
      case LetterStatus.notInWord:
        return context.dynamicColor(
          light: AppColors.greyLight,
          dark: AppColors.greyDark,
        );
      case LetterStatus.wrongSpot:
        return isHighContrast
            ? AppColors.blue
            : context.dynamicColor(
                light: AppColors.yellowLight,
                dark: AppColors.yellowDark,
              );
      case LetterStatus.correctSpot:
        return isHighContrast
            ? AppColors.orange
            : context.dynamicColor(
                light: AppColors.greenLight,
                dark: AppColors.greenDark,
              );
    }
  }

  String toEmoji() {
    switch (this) {
      case LetterStatus.unknown:
      case LetterStatus.notInWord:
        return '⬛';
      case LetterStatus.wrongSpot:
        return '🟨';
      case LetterStatus.correctSpot:
        return '🟩';
    }
  }
}
