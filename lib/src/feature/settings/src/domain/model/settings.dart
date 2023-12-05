import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:wordly/src/feature/settings/src/domain/model/general.dart';

@immutable
class const Settings({required final GeneralSettings general, required final Locale dictionary}) {
  Settings copyWith({GeneralSettings? general, Locale? dictionary}) =>
      Settings(general: general ?? this.general, dictionary: dictionary ?? this.dictionary);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          general == other.general &&
          dictionary == other.dictionary;

  @override
  int get hashCode => Object.hash(general, dictionary);
}
