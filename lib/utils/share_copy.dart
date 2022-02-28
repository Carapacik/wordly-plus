import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordle/data/dictionary_data.dart';
import 'package:wordle/data/models/letter_status.dart';
import 'package:wordle/presentation/widgets/dialogs/top_flush_bar.dart';
import 'package:wordle/resources/r.dart';

String _getEmojiStringFromGrid() {
  final letterDataList = DictionaryData.getInstance().letterDataList;
  String emojiString = "";
  letterDataList.asMap().map((key, value) {
    emojiString += value.status.toEmoji();
    if (key % 5 == 4) {
      emojiString += "\n";
    }
    return MapEntry(key, value);
  });
  return emojiString;
}

Future<void> shareEmojiString(final BuildContext context) async {
  final emojiString =
      R.stringsOf(context).check_my_result(emoji: _getEmojiStringFromGrid());
  Share.share(emojiString);
}

Future<void> copyEmojiString(
  final BuildContext context,
) async {
  final emojiString =
      R.stringsOf(context).check_my_result(emoji: _getEmojiStringFromGrid());
  await Clipboard.setData(ClipboardData(text: emojiString));
  await showTopFlushBar(
    context,
    message: R.stringsOf(context).text_copied,
  );
}
