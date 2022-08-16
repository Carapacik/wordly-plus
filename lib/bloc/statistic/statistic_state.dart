part of 'statistic_bloc.dart';

@Freezed()
class StatisticState with _$StatisticState {
  const StatisticState._();

  const factory StatisticState.initial() = _InitialState;

  const factory StatisticState.statisticLoaded(StatisticInfo? statistic) =
      _StatisticLoadedState;
}
