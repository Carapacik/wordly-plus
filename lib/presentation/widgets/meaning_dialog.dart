import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

void showMeaningDialog(
  BuildContext context, {
  required String word,
  required String meaning,
  required bool isWin,
}) {
  unawaited(
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isWin
            ? context.dynamicColor(
                light: AppColors.greenLight,
                dark: AppColors.greenDark,
              )
            : context.dynamicColor(
                light: AppColors.redLight,
                dark: AppColors.redDark,
              ),
        insetPadding:
            EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
        insetAnimationDuration: const Duration(milliseconds: 700),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 200),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                word.toUpperCase(),
                style: context.theme.tmb.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                meaning,
                style: context.theme.ll.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
