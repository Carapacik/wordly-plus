import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

Future<void> appearReview() async {
  if (kIsWeb) {
    return;
  }
  if (Platform.isAndroid || Platform.isIOS) {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }
}
