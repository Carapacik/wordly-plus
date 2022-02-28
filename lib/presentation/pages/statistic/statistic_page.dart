import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wordly/domain/daily_statistic_repository.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statisticData = GetIt.I.get<DailyStatisticRepository>().statisticData;
    final total = statisticData.losesNumber + statisticData.winsNumber;
    final winRate = total == 0 ? 0 : statisticData.winsNumber / total;
    return Scaffold(
      appBar: CustomAppBar(title: R.stringsOf(context).statistic),
      body: ConstraintScreen(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatText(
                  value: total,
                  title: R.stringsOf(context).played,
                ),
                _StatText(
                  value: winRate * 100.0,
                  title: R.stringsOf(context).win_rate,
                ),
                _StatText(
                  value: statisticData.currentStreak,
                  title: R.stringsOf(context).current_streak,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FittedBox(
                child: Text(
                  R.stringsOf(context).guess_distribution.toUpperCase(),
                  style: AppTypography.b25,
                ),
              ),
            ),
            const SizedBox(height: 4),
            _AttemptContent(attempts: statisticData.attempts),
          ],
        ),
      ),
    );
  }
}

class _StatText extends StatelessWidget {
  const _StatText({required this.value, required this.title});

  final num value;
  final String title;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: AppTypography.b25,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: AppTypography.r14,
            textAlign: TextAlign.center,
          )
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
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(4),
          ),
          height: 20,
          child: Text(
            ' ${attempts[index]}',
            style: AppTypography.m16,
          ),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 4),
    );
  }
}
