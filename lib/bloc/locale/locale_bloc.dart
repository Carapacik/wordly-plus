import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/data/repositories.dart';

part 'locale_bloc.freezed.dart';
part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc({
    required this.settingsRepository,
    required LocaleEnum locale,
  }) : super(LocaleState.changeLocale(locale)) {
    on<_LocaleChangedEvent>(_onLocaleChanged);
  }

  final ISaveSettingsRepository settingsRepository;

  Future<void> _onLocaleChanged(
    _LocaleChangedEvent event,
    Emitter<LocaleState> emit,
  ) async {
    await settingsRepository.saveLocale(event.locale);
    emit(LocaleState.changeLocale(event.locale));
  }
}
