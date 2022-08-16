part of 'locale_bloc.dart';

@Freezed()
class LocaleEvent with _$LocaleEvent {
  const LocaleEvent._();

  const factory LocaleEvent.localeChanged(LocaleEnum locale) =
      _LocaleChangedEvent;
}
