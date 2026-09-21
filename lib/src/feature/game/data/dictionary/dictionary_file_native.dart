import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> dictionaryFilePath(String name, String asset) async {
  final Directory directory = await getApplicationSupportDirectory();
  final file = File(path.join(directory.path, 'dictionaries', '$name.sqlite'));
  if (!file.existsSync()) {
    final ByteData bytes = await rootBundle.load(asset);
    await file.parent.create(recursive: true);
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes), flush: true);
    await temporary.rename(file.path);
  }
  return file.path;
}
