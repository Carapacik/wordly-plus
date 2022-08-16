import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/data/repositories.dart';

part 'levels_bloc.freezed.dart';
part 'levels_event.dart';
part 'levels_state.dart';

class LevelsBloc extends Bloc<LevelsEvent, LevelsState> {
  LevelsBloc(this.levelsRepository) : super(const LevelsState.initial()) {
    on<_LevelsLoadEvent>(_onLevelsLoad);
  }

  final ISaveLevelsRepository levelsRepository;

  Future<void> _onLevelsLoad(
    _LevelsLoadEvent event,
    Emitter<LevelsState> emit,
  ) async {
    final levels = await levelsRepository.getLevels(event.dictionary) ?? [];
    emit(LevelsState.levelsLoaded(levels));
  }
}
