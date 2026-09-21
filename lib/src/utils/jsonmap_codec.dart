import 'dart:convert';

abstract class const JsonMapCodec<T>() extends Codec<T, Map<String, Object?>> {
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
