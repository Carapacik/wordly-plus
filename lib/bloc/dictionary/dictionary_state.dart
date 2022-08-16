part of 'dictionary_bloc.dart';

@Freezed()
class DictionaryState with _$DictionaryState {
  const DictionaryState._();

  const factory DictionaryState.changeDictionary(DictionaryEnum dictionary) =
      _ChangeDictionaryState;
}
