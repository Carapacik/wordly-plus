import 'package:freezed_annotation/freezed_annotation.dart';

part 'tries.freezed.dart';
part 'tries.g.dart';

@freezed
class Tries with _$Tries {
  const factory Tries({
    @Default(0) int first,
    @Default(0) int second,
    @Default(0) int third,
    @Default(0) int fourth,
    @Default(0) int fifth,
    @Default(0) int sixth,
  }) = _Tries;

  factory Tries.fromJson(Map<String, dynamic> json) => _$TriesFromJson(json);
}
