import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/app/model/application_config.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';

String? shareString(BuildContext context, (bool, int, List<LetterInfo>)? result) {
  if (result == null) {
    return null;
  }
  final sb = StringBuffer()
    ..writeln(result.$1 ? context.l10n.checkResultWin(result.$2) : context.l10n.checkResultLose(result.$2));
  for (final String e in _splitBy5Symbols(result.$3)) {
    sb.writeln(e);
  }
  sb
    ..write('\n')
    ..writeln(context.l10n.checkResult)
    ..write(
      kIsWeb
          ? const ApplicationConfig().webLink
          : Platform.isAndroid
          ? const ApplicationConfig().androidLink
          : const ApplicationConfig().webLink,
    );
  return sb.toString();
}

List<String> _splitBy5Symbols(List<LetterInfo> letters) {
  final list = <String>[];
  final sb = StringBuffer();
  for (var i = 0; i < letters.length; i++) {
    sb.write(letters[i].status.emoji);
    if ((i + 1) % 5 == 0) {
      list.add(sb.toString());
      sb.clear();
    }
  }
  return list;
}
