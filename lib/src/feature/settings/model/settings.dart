import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:wordly/src/feature/settings/model/general.dart';

@immutable
class const Settings({
  required final GeneralSettings general,
  required final Locale dictionary,
  final bool hardMode = false,
}) {
  Settings copyWith({GeneralSettings? general, Locale? dictionary, bool? hardMode}) => Settings(
    general: general ?? this.general,
    dictionary: dictionary ?? this.dictionary,
    hardMode: hardMode ?? this.hardMode,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          general == other.general &&
          dictionary == other.dictionary &&
          hardMode == other.hardMode;

  @override
  int get hashCode => Object.hash(general, dictionary, hardMode);
}
