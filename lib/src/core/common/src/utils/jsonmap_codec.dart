import 'dart:convert';

/// {@template json_map_codec}
/// A codec for converting between a [T] and a [Map<String, Object?>].
/// {@endtemplate}
abstract class const JsonMapCodec<T>() extends Codec<T, Map<String, Object?>> {
  /// {@macro json_map_codec}
  this;

  ({T? decoded, Object? error, StackTrace? stackTrace}) tryDecode(Map<String, Object?> input) {
    try {
      return (decoded: $decode(input), error: null, stackTrace: null);
    } on Object catch (e, stackTrace) {
      return (decoded: null, error: e, stackTrace: stackTrace);
    }
  }

  T $decode(Map<String, Object?> input);

  Map<String, Object?> $encode(T input);

  @override
  Converter<Map<String, Object?>, T> get decoder => _FuncConverter<Map<String, Object?>, T>($decode);

  @override
  Converter<T, Map<String, Object?>> get encoder => _FuncConverter<T, Map<String, Object?>>($encode);
}

class const _FuncConverter<S, T>(final T Function(S) _onConvert) extends Converter<S, T> {
  @override
  T convert(S input) => _onConvert(input);
}
