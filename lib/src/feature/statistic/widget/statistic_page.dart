import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';
import 'package:wordly/src/feature/shared/not_played.dart';
import 'package:wordly/src/feature/statistic/domain/model/game_statistic.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({required this.dictionary, super.key});

  final Locale dictionary;

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late final Future<GameStatistic?> _getStatisticsFuture = context.dependencies.statisticsRepository.getStatistic(
    widget.dictionary.languageCode,
  );

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      title: context.l10n.statistic,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.statistic, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
        ),
        body: ConstraintScreen(
          child: FutureBuilder(
            future: _getStatisticsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const HaveNotPlayed();
              }
              final GameStatistic? statistic = snapshot.requireData;
              final int played = statistic!.wins + statistic.loses;
              final num winRate = played != 0 ? statistic.wins * 100 / played : 0;
              final int streak = statistic.streak;
              final int maxStreak = statistic.maxStreak;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth < 480 || MediaQuery.textScalerOf(context).scale(1) > 1.3
                            ? 2
                            : 4;
                        final double width = constraints.maxWidth / columns;
                        return Wrap(
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: width,
                              child: _StatText(value: played, title: context.l10n.played),
                            ),
                            SizedBox(
                              width: width,
                              child: _StatText(value: winRate, title: context.l10n.winRate, percent: true),
                            ),
                            SizedBox(
                              width: width,
                              child: _StatText(value: streak, title: context.l10n.currentStreak),
                            ),
                            SizedBox(
                              width: width,
                              child: _StatText(value: maxStreak, title: context.l10n.maxStreak),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FittedBox(
                        child: Text(
                          context.l10n.guessDistribution.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AttemptDistribution(attempts: statistic.attempts),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatText extends StatelessWidget {
  const _StatText({required this.value, required this.title, this.percent = false});

  final num value;
  final String title;
  final bool percent;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        percent ? '${value.toStringAsFixed(1)}%' : value.toString(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

class AttemptDistribution extends StatelessWidget {
  const AttemptDistribution({required this.attempts, this.color, this.textColor, super.key});

  final List<int> attempts;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Settings? settings = color == null || textColor == null
        ? SettingsScope.of(context, listen: true).settingsService.current
        : null;
    final Color effectiveColor = color ?? settings!.general.correctColor;
    final Color effectiveTextColor =
        textColor ?? LetterStatus.correctSpot.textColor(context, settings!.general) ?? Colors.white;
    final int maxCount = attempts.isEmpty ? 0 : attempts.reduce(max);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      itemCount: attempts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) => _AttemptRow(
        attempt: index + 1,
        count: attempts[index],
        maxCount: maxCount,
        color: effectiveColor,
        textColor: effectiveTextColor,
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({
    required this.attempt,
    required this.count,
    required this.maxCount,
    required this.color,
    required this.textColor,
  });

  final int attempt;
  final int count;
  final int maxCount;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = context.theme.textTheme.bodyMedium ?? const TextStyle();
    final painter = TextPainter(
      text: TextSpan(text: '$count', style: valueStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final double rowHeight = max(28, painter.height + 8);
    return Row(
      key: ValueKey<String>('attempt-$attempt'),
      children: [
        SizedBox(
          width: 28,
          child: Text(
            '$attempt',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: rowHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (count == 0 || maxCount == 0) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text('0', key: ValueKey<String>('attempt-$attempt-value')),
                  );
                }
                final double barWidth = constraints.maxWidth * count / maxCount;
                final bool fitsInside = barWidth >= painter.width + 16;
                final double outsideLeft = min(barWidth + 6, max(0, constraints.maxWidth - painter.width));
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: count / maxCount,
                        child: Container(
                          key: ValueKey<String>('attempt-$attempt-bar'),
                          height: rowHeight,
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: fitsInside ? max(4, barWidth - painter.width - 8) : outsideLeft,
                      top: (rowHeight - painter.height) / 2,
                      child: Text(
                        '$count',
                        key: ValueKey<String>('attempt-$attempt-value'),
                        style: valueStyle.copyWith(color: fitsInside ? textColor : null),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
