part of 'statistic_bloc.dart';

@Freezed()
class StatisticEvent with _$StatisticEvent {
  const StatisticEvent._();

  const factory StatisticEvent.statisticLoad(DictionaryEnum dictionary) =
      _StatisticLoadEvent;
}
