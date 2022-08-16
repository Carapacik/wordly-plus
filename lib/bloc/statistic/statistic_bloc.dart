import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/data/repositories.dart';

part 'statistic_bloc.freezed.dart';
part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc(this.statisticRepository)
      : super(const StatisticState.initial()) {
    on<_StatisticLoadEvent>(_onStatisticLoad);
  }

  final ISaveStatisticRepository statisticRepository;

  Future<void> _onStatisticLoad(
    _StatisticLoadEvent event,
    Emitter<StatisticState> emit,
  ) async {
    final statistic =
        await statisticRepository.getDailyStatistic(event.dictionary);
    emit(StatisticState.statisticLoaded(statistic));
  }
}
