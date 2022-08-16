part of 'locale_bloc.dart';

@Freezed()
class LocaleState with _$LocaleState {
  const LocaleState._();

  const factory LocaleState.changeLocale(LocaleEnum locale) =
      _ChangeLocaleState;
}
