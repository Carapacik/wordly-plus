import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordly/data/repositories/dictionary_repository.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/utils/utils.dart';

Future<void> shareEmojiString(
  final BuildContext context, {
  required final bool isWin,
}) async {
  final repository = GetIt.I<DictionaryRepository>();
  late String copiedText;
  if (isWin) {
    copiedText = R.stringsOf(context).check_my_result_win(
          attemptNumber: repository.currentAttempt,
          emoji: repository.getEmojiString,
        );
  } else {
    copiedText = R.stringsOf(context).check_my_result_lose(
          emoji: repository.getEmojiString,
        );
  }
  await Share.share(copiedText);
}

Future<void> copyEmojiString(
  final BuildContext context, {
  required final bool isWin,
}) async {
  final repository = GetIt.I<DictionaryRepository>();
  late String copiedText;
  if (isWin) {
    copiedText = R.stringsOf(context).check_my_result_win(
          attemptNumber: repository.currentAttempt,
          emoji: repository.getEmojiString,
        );
  } else {
    copiedText = R.stringsOf(context).check_my_result_lose(
          emoji: repository.getEmojiString,
        );
  }
  await Clipboard.setData(ClipboardData(text: copiedText));
  await showSnackBar(
    context,
    message: R.stringsOf(context).text_copied,
  );
}
