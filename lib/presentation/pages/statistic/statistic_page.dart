import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/statistic/statistic_bloc.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) => Title(
        color: AppColors.dark,
        title: context.r.statistic,
        child: Scaffold(
          appBar: CustomAppBar(title: context.r.statistic),
          body: ConstraintScreen(
            child: BlocBuilder<StatisticBloc, StatisticState>(
              builder: (context, state) => state.map(
                initial: (_) =>
                    const Center(child: CircularProgressIndicator()),
                statisticLoaded: (s) {
                  final statistic = s.statistic;
                  if (statistic == null) {
                    return const HaveNotPlayed();
                  }
                  final played = statistic.wins + statistic.loses;
                  final winRate =
                      played != 0 ? statistic.wins * 100 / played : 0;
                  final streak = statistic.streak;
                  final maxStreak = statistic.maxStreak;
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatText(
                            value: played,
                            title: context.r.played,
                          ),
                          _StatText(
                            value: winRate,
                            title: context.r.win_rate,
                            percent: true,
                          ),
                          _StatText(
                            value: streak,
                            title: context.r.current_streak,
                          ),
                          _StatText(
                            value: maxStreak,
                            title: context.r.max_streak,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FittedBox(
                          child: Text(
                            context.r.guess_distribution.toUpperCase(),
                            style: context.theme.tl,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _AttemptContent(attempts: statistic.attempts),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class _StatText extends StatelessWidget {
  const _StatText({
    required this.value,
    required this.title,
    this.percent = false,
    // ignore: unused_element
    super.key,
  });

  final num value;
  final String title;
  final bool percent;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            percent ? '${value.toStringAsFixed(1)}%' : value.toString(),
            style: context.theme.tl,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: context.theme.ll,
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class _AttemptContent extends StatelessWidget {
  const _AttemptContent({required this.attempts});

  final List<int> attempts;

  @override
  Widget build(BuildContext context) {
    final maxValue = attempts.reduce(max) + 1;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      itemCount: attempts.length,
      itemBuilder: (context, index) => FractionallySizedBox(
        alignment: Alignment.topLeft,
        widthFactor: (attempts[index] + 1) / maxValue,
        child: Container(
          decoration: BoxDecoration(
            color: context.dynamicColor(
              light: AppColors.dark,
              dark: AppColors.light,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          height: 20,
          child: Text(
            ' ${attempts[index]}',
            style: context.theme.bl.copyWith(
              color: context.dynamicColor(
                light: AppColors.light,
                dark: AppColors.dark,
              ),
            ),
          ),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 4),
    );
  }
}
